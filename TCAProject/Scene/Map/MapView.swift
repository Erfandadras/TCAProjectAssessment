//
//  MapView.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/28/24.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapKarrtView: View {
    @Perception.Bindable var store: StoreOf<MapScreen>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Map(coordinateRegion: .constant(
                    MKCoordinateRegion(
                        center: store.state.location ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                ), showsUserLocation: true).onAppear(perform: {
                    store.send(.startUpdatingLocation)
                }).onDisappear(perform: {
                    store.send(.stopUpdatingLocation)
                }).padding(.top, 24)
            }.background(ignoresSafeAreaEdges: .bottom)
        }
    }
}
