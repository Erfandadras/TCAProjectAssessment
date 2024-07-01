//
//  TCAProjectApp.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/27/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAProjectApp: App {
    let store = StoreOf<MainScreen>(initialState: MainScreen.State()) {
        MainScreen(locationService: LocationManager(),
                   shiftService: ShiftService(client: URLSession.shared))
    } withDependencies: {
        $0.urlSession = URLSession.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
//            MapKarrtView(store: .init(initialState: MapScreen.State(), reducer: {
//                MapScreen(locationService: LocationService())
//            }))
        }
    }
}
