//
//  String+Date.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/29/24.
//

import Foundation

extension String {
    func convertISODateString() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
        guard let date = isoFormatter.date(from: self) else {return nil}
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"  // Format for "11:30 am"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        let timeString = timeFormatter.string(from: date)
        
        return timeString
    }
}
