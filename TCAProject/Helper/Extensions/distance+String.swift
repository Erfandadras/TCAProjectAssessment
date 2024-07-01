//
//  String+distance.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/29/24.
//

import CoreLocation


extension CLLocationDistance {
    func formatDistance() -> String {
        if self >= 1000 {
            let distanceInKilometers = self / 1000
            return String(format: "%.0fKM", distanceInKilometers)
        } else {
            return String(format: "%.0fM", self)
        }
    }
}
