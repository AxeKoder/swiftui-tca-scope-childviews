//
//  ContentView.swift
//  TCA_Tutorial
//
//  Created by Daeho Park on 12/23/24.
//

import SwiftUI
import ComposableArchitecture

struct Feature: Reducer {
    struct CounterState: Equatable {
        var count = 0
    }

    enum CounterAction: Equatable {
        case addCount
        case subtractCount
    }
    
    func reduce(into state: inout CounterState, action: CounterAction) -> Effect<CounterAction> {
        switch action {
        case .addCount:
            state.count += 1
            return .none
        case .subtractCount:
            state.count -= 1
            return .none
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Feature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Button("-") { viewStore.send(.subtractCount) }
                    .font(.largeTitle)
                    .bold()
                Text("Count = \(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                Button("+") { viewStore.send(.addCount) }
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
        }
    }
}

#Preview {
    let store = Store(
        initialState: Feature.CounterState(),
        reducer: { Feature() }
    )
    CounterView(store: store)
}
