//
//  TCAProjectTests.swift
//  TCAProjectTests
//
//  Created by Erfan mac mini on 6/30/24.
//

import XCTest
import Foundation
import ComposableArchitecture
@testable import TCAProject


// Mock LocationService


@MainActor
final class TCAProjectTests: XCTestCase {
    // MARK: - properties
    var mockLocationService: MockLocationService!
    var mockService: ShiftServiceProtocol!
    var mockData: [RMShiftModel]!
    var scheduler: TestSchedulerOf<DispatchQueue>!
    
    // MARK: - setup test case
    override func setUp() {
        super.setUp()
        mockData = [RMShiftModel(id: "1"), RMShiftModel(id: "2")]
        mockService = MockShiftService(mockData: mockData)
        mockLocationService = MockLocationService()
        scheduler = DispatchQueue.test
    }
    
    // MARK: - tear down
    override func tearDown() {
        mockLocationService = nil
        super.tearDown()
    }
    
    // MARK: - test fetch data
    func testFetchDataSuccess() async {
        let expectedUIModels = mockData.compactMap({ UIShiftModel(shift: $0) }) // uiModel
        
        let store = TestStore(initialState: MainScreen.State()) {
            MainScreen(locationService: mockLocationService, shiftService: mockService)
        }
        
        store.exhaustivity = .off
        await store.send(.fetchData(date: "2024-06-27"))
        sleep(4) // simulate network session
        await store.skipReceivedActions()
        store.assert { state in
            state.isLoading = false
            state.error = nil
            state.shifts = expectedUIModels
        }
    }
    
    // MARK: - start updating location
    func testStartUpdatingLocation() async {
        let store = TestStore(initialState: MainScreen.State()) {
            MainScreen(locationService: mockLocationService, shiftService: mockService)
        }
        store.exhaustivity = .off
        
        await store.send(.startUpdatingLocation)
        mockLocationService.sendMockData()
        await store.skipReceivedActions()
        store.assert {
            $0.location = MockLocationService.mockLocation
        }
    }
    
    // MARK: - filter button tapped
    func testFilterButtonDidTapped() async {
        let store = TestStore(initialState: MainScreen.State()) {
            MainScreen(locationService: mockLocationService, shiftService: mockService)
        }
        
        store.exhaustivity = .off
        await store.send(.filterButtonDidTapped)
        
        store.assert {
            $0.destination = .filter
        }
        
    }
}
