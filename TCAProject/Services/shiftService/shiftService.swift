
//
//  ShiftService.swift
//  TCAProjectTests
//
//  Created by Erfan mac mini on 6/30/24.
//


import Foundation

protocol ShiftServiceProtocol {
    func LoadAllShifts(for date: String) async throws -> [RMShiftModel]
}

class ShiftService: ShiftServiceProtocol {
    // MARK: - properties
    let client: HttpClient // URLSession
    
    // init
    init(client: HttpClient) {
        self.client = client
    }
    
    // MARK: - load data
    func LoadAllShifts(for date: String) async throws -> [RMShiftModel] {
        let shifts: [RMShiftModel] = try await withCheckedThrowingContinuation {[client] continuation in
            guard let request =  ShiftService.makeRequest(for: date) else {
                continuation.resume(throwing: InvalidHTTPResponseError())
                return
            }
            client.publisher(request: request) { result in
                switch result {
                case .success(let success):
                    do {
                        continuation.resume(returning: try ShiftDataMapper.mapper(data: success.0, response: success.1))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
        return shifts
    }
}

// MARK: - create request for keyword and default params 
extension ShiftService {
    // for date: String -> create URL request
    static func makeRequest(for date: String) -> URLRequest? {
        guard var urlComponent = URLComponents(string:  API.baseUrl) else {
            return nil
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "filter[data]", value: date)
        ]
        guard let url = urlComponent.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
