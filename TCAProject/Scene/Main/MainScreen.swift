//
//  MainScreen.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/27/24.
//

import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct MainScreen {
    // MARK: - dependencies
    var locationService: LocationService
    var shiftService: ShiftServiceProtocol
    
    // MARK: - Destination
    @Reducer
    struct Destination {
        enum State {
            case filter
            case signup
            case login
            case map(MapScreen.State)
        }
        
        enum Action {
            case filter
            case signup
            case login
            case map(MapScreen.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.map, action: \.map) {
                MapScreen(locationService: LocationManager())
            }
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        let id = UUID() // for confirm Equatable
        @Presents var destination: Destination.State?
//        @Presents var mapState: MapScreen.State?
        var location: CLLocationCoordinate2D? // user last location
        var shifts: [UIShiftModel] = []
        var isLoading = true
        var error: String?
        
        // Equatable func
        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    enum Action {
        case fetchData(date: String)
        case response(data: [RMShiftModel])
        case startUpdatingLocation
        case didUpdateLocation(location: CLLocationCoordinate2D?)
        case stopUpdatingLocation
        case error(error: String)
        case destination(PresentationAction<Destination.Action>)
//        case map(PresentationAction<MapScreen.Action>)
        
        // button actions
        case kaartButtonDidTapped
        case filterButtonDidTapped
        case loginButtonDidTapped
        case signinButtonDidTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                // perform url request
            case .fetchData(let date):
                return .run(priority: .background) { send in
                    let data = try await shiftService.LoadAllShifts(for: date)
                    await send(.response(data: data))
                    
                } catch: { error, send in
                    await send(.error(error: error.localizedDescription))
                }
                
                
                // receive data
            case .response(data: let data):
                state.isLoading = false
                state.error = nil
                let uiModels = data.compactMap({UIShiftModel(shift: $0)})
                state.shifts = uiModels
                
                // start location service and observe stream data
            case .startUpdatingLocation:
                return .run { send in
                    for await location in locationService.requestLocation() {
                        await send(.didUpdateLocation(location: location))
                    }
                }
                
                // receive location
            case .didUpdateLocation(location: let location):
                state.location = location
                // other way to calculate the distance
                //                for var shift in state.shifts {
                //                    shift.updateDistance(with: location)
                //                    state.shifts.replaceOrAppend(shift, firstMatchingKeyPath: \.id)
                //                }
                
                // receive stop location
            case .stopUpdatingLocation:
                locationService.stopUpdatingLocation()
                
                // main screen receive error
            case .error(error: let err):
                state.isLoading = false
                state.error = err
                
            // MARK: - destination action connections
            case .destination(.presented(.map(.stopUpdatingLocation))):
                print("sopped")
                
            case .destination(_): break

            
                // CTA's
            case .kaartButtonDidTapped:
                state.destination = .map(.init())
                
            case .filterButtonDidTapped:
                print("filterButtonDidTapped")
                state.destination = .filter
                
            case .loginButtonDidTapped:
                state.destination = .login
                
            case .signinButtonDidTapped:
                state.destination = .signup
            }
            return .none
        }.ifLet(\.$destination, action: \.destination) {
            Destination()
            
        }
    }
}
