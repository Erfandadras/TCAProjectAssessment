//
//  LocationService.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/28/24.
//

import Foundation
import Combine
import MapKit
import ComposableArchitecture

// MARK: - location error
enum LocationError: Error, Equatable {
    case unableToDetermineLocation
}

// MARK: - location service
protocol LocationService {
    var location: AsyncStream<CLLocationCoordinate2D?>.Continuation? {get set}
    func requestLocation() -> AsyncStream<CLLocationCoordinate2D?>
    func stopUpdatingLocation()
}

// MARK: - location manager
class LocationManager: NSObject, CLLocationManagerDelegate, LocationService {
    // MARK: - properties
    private let locationManager = CLLocationManager()
    internal var location: AsyncStream<CLLocationCoordinate2D?>.Continuation?
    
    
    // MARK: - init
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - request location
    func requestLocation() -> AsyncStream<CLLocationCoordinate2D?> {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
        // return Asyncable stream location
        return AsyncStream { continuation in
            self.location = continuation
            continuation.onTermination = { _ in // on finished with termination
                self.locationManager.stopUpdatingLocation()
                self.location = nil
            }
        }
    }
    
    // MARK: - stop location
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // send last location to stream
        location?.yield(locations.last?.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: - unhandled errors
        print("Location Manager Error: \(error.localizedDescription)")
    }
}
