//
//  SettingsDetailVC.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit

struct SettingsItemCell {
    let title: String
    let cellType: SettingsCellType
}

class SettingsDetailVC: UITableViewController {

    let globalSettingsModel = GlobalDrawingSettingsModel.shared

    var settingsCells: [SettingsItemCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        tableView.register(MenuBTNSettingsItem.self, forCellReuseIdentifier: MenuBTNSettingsItem.reuseID)
        configureSettingsCells()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingItem = settingsCells[indexPath.row]

        switch settingItem.cellType {
            case .menu(let options, let selectedOption, let onSelection):
                let menuCell = tableView.dequeueReusableCell(withIdentifier: MenuBTNSettingsItem.reuseID,
                                                             for: indexPath) as! MenuBTNSettingsItem
                menuCell.setup(with: options, selectedOption: selectedOption)
                menuCell.onOptionSelected = onSelection
                menuCell.titleLabel.text = settingItem.title
                return menuCell
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCells.count
    }

    // Overridden by subclasses
    func configureSettingsCells() { }
}
