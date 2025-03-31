//
//  SettingsCellType.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import Foundation

enum SettingsCellType {
    case menu(options: [String], selectedOption: String?, onSelection: ((String) -> Void)?)
}
