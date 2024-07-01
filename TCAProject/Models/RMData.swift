//
//  RMData.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/27/24.
//

import Foundation

struct RMData<T: Decodable>: Decodable {
    let data: T?
}
