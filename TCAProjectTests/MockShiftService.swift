//
//  MockShiftService.swift
//  TCAProjectTests
//
//  Created by Erfan mac mini on 6/30/24.
//

import Foundation
@testable import TCAProject

class MockShiftService: ShiftServiceProtocol {
    let mockData: [RMShiftModel]
    
    init(mockData: [RMShiftModel]) {
        self.mockData = mockData
    }
    
    func LoadAllShifts(for date: String) async throws -> [TCAProject.RMShiftModel] {
        let shifts: [RMShiftModel] = try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                continuation.resume(returning: self.mockData)
            }
        }
        
        return shifts
    }
}
