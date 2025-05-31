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
  
  enum Action: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
    case factButtonTapped
    case factResponse(String)
    case childAction(IdentifiedActionOf<ChildSnowFeature>)
    case updateChild(id: Int, countValue: Int)
  }
  
  enum CancelID {
    case timer
  }
    
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
            let (data, _) = try await URLSession.shared
              .data(from: URL(string: "http://numbersapi.com/\(count)")!)
            let fact = String(decoding: data, as: UTF8.self)
            await send(.factResponse(fact))
          }
          .cancellable(id: CancelID.timer)
        } else {
          return .cancel(id: CancelID.timer)
        }
        
      case .factResponse(let fact):
        state.fact = fact
        state.isLoading = false
        let states = (0..<5).map {
          ChildSnowFeature.State(id: $0, count: state.count, title: "\($0): \(fact)")
        }
        state.childStates = IdentifiedArray(uniqueElements: states)
        return .none
        
//      case .childAction(let identifiedAction):
//        switch identifiedAction {
//        case .update(let id):
//          return .none
//        }
      case let .updateChild(id, countValue):
        let updated = "id \(id) is changed! count = \(countValue)"
        state.childStates[id: id]?.title = updated
        state.childStates[id: id]?.count = countValue
        return .none
      
      case let .childAction(.element(id, action: .update(updateId))):
        print(".childAction called, id = \(id), updateId = \(updateId)")
        var count = state.childStates[id: id]?.count ?? 0
        count += 1
        return .send(.updateChild(
          id: id,
          countValue: count
        ))
      }
    }
    .forEach(\.childStates, action: \.childAction) {
      ChildSnowFeature()
    }
  }
}
