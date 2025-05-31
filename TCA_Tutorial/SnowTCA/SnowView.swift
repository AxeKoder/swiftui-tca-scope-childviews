//
//  SnowView.swift
//  TCA_Tutorial
//
//  Created by Daeho Park on 5/21/25.
//

import SwiftUI
import ComposableArchitecture

struct SnowView: View {
  let store: StoreOf<SnowFeature>
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 4) {
        Button("+") { store.send(.incrementButtonTapped) }
          .font(.largeTitle)
        
        Text("Snow Count = \(store.count)")
          .background(Color.teal)
          .font(.title)
        
        Button("-") { store.send(.decrementButtonTapped) }
          .font(.largeTitle)
        
        Button("Check fact of \(store.count)") { store.send(.factButtonTapped) }
          .font(.subheadline)
        
        Text("\(store.fact ?? "")")
          .font(.headline)
          .shadow(radius: 0.4)
        
        Divider()
          .padding(.horizontal, 14)
          .frame(height: 12)
        
        ForEach(store.scope(state: \.childStates, action: \.childAction)) { store in
          ChildSnowView(store: store)
        }
        
      }
      .padding()
      .bold()
    }
  }
}

#Preview {
  SnowView(store: Store(
    initialState: SnowFeature.State(),
    reducer: { SnowFeature() }
  ))
}
