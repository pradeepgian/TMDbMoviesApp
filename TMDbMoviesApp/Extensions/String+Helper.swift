//
//  String+Helper.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 27/03/24.
//

import Foundation

extension String {
    func formatDateString(from currentFormat: String, to newFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = newFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func extractYear() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return year
        } else {
            return nil
        }
    }
    
}
