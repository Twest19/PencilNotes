//
//  SettingsVC.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit
import PencilKit

struct BasicTableCellModel {
    var title: String?
    var group: FileGroupOption?
    var settingsOption: SettingsOption?
}

protocol SelectedSettingDelegate: AnyObject {
    func didSelect(option setting: BasicTableCellModel)
}

class SettingsVC: UISplitViewController, UISplitViewControllerDelegate {

    static let options: [BasicTableCellModel] = [
        BasicTableCellModel(settingsOption: .canvas),
        BasicTableCellModel(settingsOption: .tool)
    ]

    let globalSettings = GlobalDrawingSettingsModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [configureStaticSettings()]
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        delegate = self
    }

    func configureStaticSettings() -> UITableViewController {
        let primaryVC = PrimaryTableVC(options: Self.options, delegate: self, style: .insetGrouped)
        primaryVC.title = "Settings"
        primaryVC.navigationItem.hidesBackButton = true
        return primaryVC
    }
}

extension SettingsVC: SelectedSettingDelegate {
    func didSelect(option setting: BasicTableCellModel) {
        guard let settingsOption = setting.settingsOption else { return }
        setViewController(settingsOption.settingsVC, for: .secondary)
    }
}
