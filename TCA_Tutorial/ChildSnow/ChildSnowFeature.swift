//
//  ChildSnowFeature.swift
//  TCA_Tutorial
//
//  Created by Daeho Park on 5/31/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ChildSnowFeature {
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: Int
    var count: Int
    var title: String
    var isLoading: Bool = false
  }
  
  enum Action {
    case update(id: Int)
    case updateCount
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .updateCount:
        state.count += 1
        let title = "id \(state.id) is changed! count = \(state.count)"
        state.title = title
        return .none
      default:
        return .none
      }
    }
  }
}

