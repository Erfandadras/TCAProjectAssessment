//
//  JobItemView.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/27/24.
//

import SwiftUI
import CoreLocation
import SDWebImageSwiftUI
import ComposableArchitecture

struct JobItemView: View {
    // MARK: - properties
    let data: UIShiftModel
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: - Body
    var body: some View {
        WithPerceptionTracking {
            VStack {
                ZStack(alignment: .bottom) {
                    WebImage(url: data.banner) { image in
                          image.resizable()
                      } placeholder: {
                          Image(systemName: "photo")
                              .resizable()
                              .scaledToFit()
                              .aspectRatio(1.77, contentMode: .fit)
                              .foregroundColor(.gray)
                      }
                        .onSuccess { image, data, cacheType in }
                        .resizable()
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition
                        .scaledToFill()
                        .aspectRatio(1.77, contentMode: .fit)
                        .cornerRadius(12, corners: .allCorners)
                    
                    HStack {
                        Spacer()
                        Text(data.earning)
                            .foregroundStyle(.black)
                            .font(.callout)
                            .padding(.leading ,12)
                            .padding(.top ,8)
                            .background(.white)
                            .cornerRadius(24, corners: .topLeft)
                    }
                    
                }
                
                HStack {
                    Text("SERVING . \(calculateDistance(destinationLocation: data.location, currentLocation: currentLocation) ?? "Unknown")")
                        .foregroundStyle(.purple)
                        .font(.caption.weight(.semibold))
                    Spacer()
                }
                
                HStack {
                    Text(data.title)
                        .foregroundStyle(.black)
                        .font(.callout)
                    Spacer()
                }
                
                HStack {
                    Text(data.date)
                        .foregroundStyle(.black.opacity(0.7))
                        .font(.caption2)
                    Spacer()
                }
            }.ignoresSafeArea()
        }
    }
    
    // MARK: - bind user last location and shift location to return Distance in between
    func calculateDistance(destinationLocation: CLLocation?, currentLocation: CLLocationCoordinate2D?) -> String? {
        guard let destinationLocation = destinationLocation,
                let coordinate = currentLocation else {return nil}
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location.distance(from: destinationLocation).formatDistance()
    }
}
