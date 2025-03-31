//
//  SettingsOption.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import Foundation

enum SettingsOption: String {
    case canvas = "Canvas"
    case tool = "Tool"

    var settingsVC: SettingsDetailVC {
        switch self {
            case .canvas:
                CanvasSettingsVC(style: .insetGrouped)
            case .tool:
                ToolSettingsVC(style: .insetGrouped)
        }
    }
}
