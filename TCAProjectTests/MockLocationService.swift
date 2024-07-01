//
//  MockLocationService.swift
//  TCAProjectTests
//
//  Created by Erfan mac mini on 7/1/24.
//

import CoreLocation
@testable import TCAProject

class MockLocationService: LocationService {
    func stopUpdatingLocation() {}
    
    static let mockLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    var location: AsyncStream<CLLocationCoordinate2D?>.Continuation?
    
    func sendMockData() {
        self.location?.yield(MockLocationService.mockLocation)
    }
    
    func requestLocation() -> AsyncStream<CLLocationCoordinate2D?> {
        return AsyncStream { continuation in
            self.location = continuation
            
            continuation.onTermination = { _ in
                self.location = nil
            }
        }
    }
}
