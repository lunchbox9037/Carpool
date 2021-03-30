//
//  DateFormatter.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/25/21.
//

import Foundation

extension Date {
    enum DateFormatType: String {
           case full = "EEEE, MMM d, yyyy"
           case fullNumeric = "MM/dd/yyyy"
           case fullNumericTimestamp = "MM-dd-yyyy HH:mm"
           case monthDayTimestamp = "MMM d, h:mm a"
           case monthYear = "MMMM yyyy"
           case monthDayYear = "MMM d, yyyy"
           case fullWithTimezone = "E, d MMM yyyy HH:mm:ss Z"
           case fullNumericWithTimezone = "yyyy-MM-dd'T'HH:mm:ssZ"
           case short = "dd.MM.yy"
           case timestamp = "HH:mm:ss.SSS"
        }
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}
