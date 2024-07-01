//
//  ShiftDataMapper.swift
//  TCAProjectTests
//
//  Created by Erfan mac mini on 6/30/24.
//

import Foundation

/// map RM Data to RMShift model and throw proper errors base on different status code
struct ShiftDataMapper {
    static func mapper(data: Data, response: HTTPURLResponse) throws -> [RMShiftModel] {
        if response.statusCode == 204 {
            return []
        }
        
        if response.statusCode == 200 {
            do {
                let shifts = try JSONDecoder().decode(RMData<[RMShiftModel]>.self, from: data).data ?? []
                return shifts
            } catch {
                throw error
            }
        }
        
        // handle other status codes
        return []
    }
}
