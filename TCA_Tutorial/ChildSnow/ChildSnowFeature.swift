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
  
  enum Action: Equatable {
    case update(id: Int)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
          return .none
      }
    }
  }
}

