//
//  UIShiftModel.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/28/24.
//

import Foundation
import CoreLocation
import ComposableArchitecture


struct UIShiftModel: Identifiable {
    let id: String
    let location: CLLocation?
    let title: String
    let date: String
    let earning: String
    let banner: URL?
    var distance: String?
    
    init(shift: RMShiftModel) {
        self.id = shift.id ?? UUID().uuidString
        self.location = shift.job?.address?.location
        self.title = shift.job?.client ?? "Unknown"
        self.date = String(format: "%@ - %@", shift.startAt ?? "", shift.endAt ?? "")
        self.earning = shift.earnings ?? "Not Specified"
        self.banner = shift.job?.imageURL
    }
    
    mutating func updateDistance(with coordinate: CLLocationCoordinate2D?) {
        self.distance = calculateDistance(destinationLocation: location, currentLocation: coordinate)
    }
    
    func calculateDistance(destinationLocation: CLLocation?, currentLocation: CLLocationCoordinate2D?) -> String? {
        guard let destinationLocation = destinationLocation,
                let coordinate = currentLocation else {return nil}
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location.distance(from: destinationLocation).formatDistance()
    }
}
