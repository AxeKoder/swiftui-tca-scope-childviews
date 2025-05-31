//
//  TCA_TutorialApp.swift
//  TCA_Tutorial
//
//  Created by Daeho Park on 12/23/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_TutorialApp: App {
    
    static let store = Store(initialState: SnowFeature.State()) {
        SnowFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            SnowView(store: TCA_TutorialApp.store)
        }
    }
}
