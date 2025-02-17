//
//  FormatDate.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 16/02/25.
//

import Foundation

func formatDate(input: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let date = dateFormatter.date(from: input) {
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    return ""
}
