//
//  SnowFeature.swift
//  TCA_Tutorial
//
//  Created by Daeho Park on 5/28/25.
//

import ComposableArchitecture
import Foundation

struct Work {
    let title: String
    let subWorks: [Subwork]
}

struct Subwork {
    let title: String
    let desc: String
}

@Reducer
struct SnowFeature: Reducer {
  @ObservableState
  struct State {
    var count = 0
    var fact: String?
    var isLoading = false
    var endWorking = false
    var childStates: IdentifiedArrayOf<ChildSnowFeature.State>  = []
  }
  
  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case factButtonTapped
    case fetchNumber(id: Int)
    case factResponse(String)
    case childAction(IdentifiedActionOf<ChildSnowFeature>)
    case updateChild(id: Int, countValue: Int)
  }
  
  enum CancelID {
    case timer
  }
  
  var networkService: SnowNetworkService = SnowNetwork()
    
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        state.childStates = []
        return .none
      case .incrementButtonTapped:
        state.count += 1
        state.childStates = []
        return .none
      case .factButtonTapped:
        if !state.endWorking {
          state.isLoading = true
          return .run { [count = state.count] send in
            let fact = try await networkService.fetchFact(count)
            await send(.factResponse(fact))
          }
          .cancellable(id: CancelID.timer)
        } else {
          return .cancel(id: CancelID.timer)
        }
        
      case .fetchNumber(let id):
        return .run { [count = state.count] send in
          let fact = try await networkService.fetchFact(count)
          await send(.factResponse(fact))
        }
        
      case .factResponse(let fact):
        state.fact = fact
        state.isLoading = false
        let states = (0..<5).map {
          ChildSnowFeature.State(id: $0, count: state.count, title: "\($0): \(fact)")
        }
        state.childStates = IdentifiedArray(uniqueElements: states)
        return .none
      
      case let .childAction(.element(id, action: .update(updateId))):
        print(".childAction called, id = \(id), updateId = \(updateId)")
        return .send(.childAction(.element(id: id, action: .updateCount)))
        
      default: return .none
      }
    }
    .forEach(\.childStates, action: \.childAction) {
      ChildSnowFeature()
    }
  }
}
