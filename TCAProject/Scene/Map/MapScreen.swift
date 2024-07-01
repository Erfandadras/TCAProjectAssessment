//
//  MapScreen.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/28/24.
//

import ComposableArchitecture
import Foundation
import Combine
import MapKit

@Reducer
struct MapScreen {
    var locationService: LocationService
    
    @ObservableState
    struct State: Equatable {
        static func == (lhs: MapScreen.State, rhs: MapScreen.State) -> Bool {
            lhs.location == rhs.location && lhs.error == rhs.error
        }
        
        var error: String?
        var location: CLLocationCoordinate2D?
    }
    
    enum Action {
        case didUpdateLocation(location: CLLocationCoordinate2D?)
        case failed(error: Error)
        case startUpdatingLocation
        case stopUpdatingLocation
    }
    
//    @Dependency(\.locationService) var locationService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startUpdatingLocation:
                return .run { send in
                    for await location in locationService.requestLocation() {
                        await send(.didUpdateLocation(location: location))
                    }
                }
            case .stopUpdatingLocation:
                locationService.stopUpdatingLocation()
                
            case .didUpdateLocation(location: let location):
                state.location = location
                print("didUpdateLocation on map", location)
            case .failed(error: let error):
                state.error = error.localizedDescription
            }
            
            return .none
        }
        
    }
}
