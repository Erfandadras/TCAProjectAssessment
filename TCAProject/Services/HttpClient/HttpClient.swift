//
//  HttpClient.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/30/24.
//

import Foundation

// MARK: - Request client
protocol HttpClient {
    func publisher(request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}
