//
//  FileGroupOption.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit

enum FileGroupOption: String, CaseIterable {
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case blue = "Blue"
    case none = "None"

    var color: UIColor {
        switch self {
            case .red:
                    .systemRed
            case .orange:
                    .systemOrange
            case .yellow:
                    .systemYellow
            case .green:
                    .systemGreen
            case .blue:
                    .systemBlue
            case .none:
                    .clear
        }
    }

    static var availableOptions: [FileGroupOption] {
        return allCases.filter { $0 != .none }
    }
}
