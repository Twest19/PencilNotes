//
//  CanvasTheme.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit

enum CanvasTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case `default` = "Default"

    var backgroundColor: UIColor {
        switch self {
            case .light:
                    .white
            case .dark:
                    .black
            case .default:
                    .systemBackground
        }
    }
}
