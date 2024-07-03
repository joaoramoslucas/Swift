//
//  Double+.swift
//  ChefDelivery
//
//  Created by Jao on 26/06/24.
//

import Foundation

extension Double {
    func FormatPrice() -> String {
        let formatString = String(format: "%.2f",   self)
        return formatString.replacingOccurrences(of: ".", with: ",")
    }
}
