//
//  ChildSnowView.swift
//  TCA_Tutorial
//
//  Created by Daeho Park on 5/31/25.
//

import SwiftUI
import ComposableArchitecture

struct ChildSnowView: View {
  let store: StoreOf<ChildSnowFeature>
  
  var body: some View {
      VStack {
        Button("\(store.title)") {
          store.send(.update(id: store.state.id))
        }
        .font(.headline)
      }
    }
}

#Preview {
  ChildSnowView(store: Store(
    initialState: ChildSnowFeature.State(id: 0, count: 0, title: ""), reducer: {
      ChildSnowFeature()
    }
  ))
}
