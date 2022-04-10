//
//  Formatter.swift
//  
//

import Foundation

enum Formatter {
    
    static func getStringFromDateFormatter(date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy - HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getStringFromDateFormatter2(date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy - HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getDateFromStringFormatter(dateStr: String?) -> Date? {
        guard let dateStr = dateStr else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy - HH:mm"
        return dateFormatter.date(from: dateStr)
    }
}
