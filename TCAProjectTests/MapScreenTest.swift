//
//  MapScreenTest.swift
//  TCAProjectTests
//
//  Created by Erfan mac mini on 7/1/24.
//

import XCTest
import Foundation
import ComposableArchitecture
@testable import TCAProject

@MainActor
final class MapScreenTest: XCTestCase {
    // MARK: - properties
    var mockLocationService: MockLocationService!
    
    // MARK: - setup test case
    override func setUp() {
        super.setUp()
        mockLocationService = MockLocationService()
    }
    
    // MARK: - test updating location
    func testStartUpdatingLOcation() async {
        let store = TestStore(initialState: MapScreen.State()) {
            MapScreen(locationService: mockLocationService)
        }
        
        store.exhaustivity = .off
        
        await store.send(.startUpdatingLocation)
        mockLocationService.sendMockData()
        
        await store.skipReceivedActions()
        store.assert {
            $0.location = MockLocationService.mockLocation
        }
    }
}
