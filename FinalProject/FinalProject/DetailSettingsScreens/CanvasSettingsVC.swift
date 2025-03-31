//
//  CanvasSettingsVC.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit
import PencilKit

class CanvasSettingsVC: SettingsDetailVC {

    var selectedDrawingPolicy: MyDrawingPolicy {
        MyDrawingPolicy(policy: globalSettingsModel.drawingPolicy)
    }

    var selectedCanvasTheme: CanvasTheme {
        globalSettingsModel.canvasTheme
    }

    enum MyDrawingPolicy: String, CaseIterable {
        case anyInput = "Any Input"
        case pencilOnly = "Pencil Only"

        init(policy: PKCanvasViewDrawingPolicy) {
            if policy == .pencilOnly {
                self = .pencilOnly
            }
            else {
                self = .anyInput
            }
        }

        var policy: PKCanvasViewDrawingPolicy {
            switch self {
                case .anyInput:
                        .anyInput
                case .pencilOnly:
                        .pencilOnly
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Canvas"
    }

    override func configureSettingsCells() {
        settingsCells = [getCanvasPolicy(), getCanvasTheme()]
        tableView.reloadData()
    }

    func getCanvasPolicy() -> SettingsItemCell {
        let options = MyDrawingPolicy.allCases.map { $0.rawValue }
        let cellType: SettingsCellType = .menu(options: options, selectedOption: selectedDrawingPolicy.rawValue)
        { [weak self] selectedOption in
            guard let self else { return }
            if let selectedPolicy = MyDrawingPolicy(rawValue: selectedOption) {
                if selectedPolicy == .anyInput {
                    presentFingerDrawingAlert()
                }
                globalSettingsModel.drawingPolicy = selectedPolicy.policy
            }
        }

        return SettingsItemCell(title: "Input Type", cellType: cellType)
    }

    func getCanvasTheme() -> SettingsItemCell {
        let options = CanvasTheme.allCases.map { $0.rawValue }
        let cellType: SettingsCellType = .menu(options: options, selectedOption: selectedCanvasTheme.rawValue)
        { [weak self] selectedOption in
            guard let self else { return }
            if let selectedTheme = CanvasTheme(rawValue: selectedOption) {
                globalSettingsModel.canvasTheme = selectedTheme
            }
        }

        return SettingsItemCell(title: "Canvas Theme", cellType: cellType)
    }

    private func presentFingerDrawingAlert() {
        guard !globalSettingsModel.hasPresentedFingerDrawingAlert else { return }
        let alert = Helper.createBasicAlert(title: "Warning!",
                                            message: "When Finger Drawing is allowed - Two fingers ✌️ are required to scroll multi-page PDF documents.") { _ in
            self.globalSettingsModel.hasPresentedFingerDrawingAlert = true
        }
        present(alert, animated: true)
    }
}
