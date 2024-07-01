//
//  Session.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/30/24.
//

import Foundation

// MARK: - bridge URL session and HTTP Client 
extension URLSession: HttpClient {
    func publisher(request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(InvalidHTTPResponseError()))
                return
            }
            completion(.success((data, response)))
        }.resume()
    }
}
