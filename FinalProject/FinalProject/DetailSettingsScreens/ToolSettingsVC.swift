//
//  ToolSettingsVC.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit
import PencilKit

class ToolSettingsVC: SettingsDetailVC {

    var selectedTool: MyPKTool {
        globalSettingsModel.defaultTool
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tool"
    }

    override func configureSettingsCells() {
        let defaultTool = getDefaultTool()
        settingsCells = [defaultTool]
        tableView.reloadData()
    }

    func getDefaultTool() -> SettingsItemCell {
        let options = MyPKTool.allCases.map { $0.rawValue }
        let cellType: SettingsCellType = .menu(options: options, selectedOption: selectedTool.rawValue)
        { [weak self] newSelection in
            guard let self else { return }
            let newTool = MyPKTool(rawValue: newSelection)
            if let newTool {
                globalSettingsModel.defaultTool = newTool
            }
        }

        return SettingsItemCell(title: "Drawing Tool", cellType: cellType)
    }
}
