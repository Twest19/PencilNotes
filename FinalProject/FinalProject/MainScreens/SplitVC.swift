//
//  SplitVC.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit


class SplitVC: UISplitViewController {

    static var groupOptions: [BasicTableCellModel] {
        FileGroupOption.availableOptions.map { BasicTableCellModel(group: $0) }
    }

    var settingsBTNView: BasicNotesBTN!

    override func viewDidLoad() {
        super.viewDidLoad()

        let secondaryVC = configureSecondaryVC()
        let primaryVC = configurePrimaryVC(secondaryVC)

        viewControllers = [primaryVC, secondaryVC]
        preferredDisplayMode = .twoBesideSecondary
        presentsWithGesture = false
        configureSettingsButton()
    }

    func configurePrimaryVC(_ delegate: FileGroupDelegate) -> UITableViewController {
        var options = [BasicTableCellModel(title: "All Notes")]
        options.append(contentsOf: Self.groupOptions)
        let fileGroupTableVC = PrimaryTableVC(options: options, delegate: delegate, style: .plain)
        fileGroupTableVC.title = "File Groups"
        return fileGroupTableVC
    }

    func configureSecondaryVC() -> CanvasSelectionVC {
        let secondaryVC = CanvasSelectionVC()
        return secondaryVC
    }

    private func configureSettingsButton() {
        let settingsBTN = BasicNotesBTN(color: .systemGreen, systemImage: "gearshape.fill")
        settingsBTN.configuration?.buttonSize = .large
        settingsBTN.addTarget(self, action: #selector(settingsBTNAction), for: .touchUpInside)
        settingsBTNView = settingsBTN
        view.addSubview(settingsBTNView)

        NSLayoutConstraint.activate([
            settingsBTN.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            settingsBTN.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }

    @objc
    private func settingsBTNAction(_ sender: UIButton) {
        let settingsVC = SettingsVC(style: .doubleColumn)
        settingsVC.modalPresentationStyle = .pageSheet
        present(settingsVC, animated: true)
    }
}
