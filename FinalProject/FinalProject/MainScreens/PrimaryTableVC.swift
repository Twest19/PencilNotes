//
//  PrimaryTableVC.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit

class PrimaryTableVC: UITableViewController {

    weak var settingsDelegate: SelectedSettingDelegate?
    weak var fileGroupDelegate: FileGroupDelegate?

    var options: [BasicTableCellModel]

    init(options: [BasicTableCellModel], style: UITableView.Style) {
        self.options = options
        super.init(style: style)
    }

    init(options: [BasicTableCellModel], delegate: SelectedSettingDelegate, style: UITableView.Style) {
        self.options = options
        self.settingsDelegate = delegate
        super.init(style: style)
    }

    init(options: [BasicTableCellModel], delegate: FileGroupDelegate, style: UITableView.Style) {
        self.options = options
        self.fileGroupDelegate = delegate
        super.init(style: style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureTableView() {
        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseID)
        self.tableView.contentInset = .init(top: 5, left: 5, bottom: 5, right: 5)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseID,
                                                       for: indexPath) as? SettingsCell
        else { return UITableViewCell() }
        let model = options[indexPath.row]
        cell.updateCell(model)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = options[indexPath.row]
        informDelegate(selectedOption)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    private func informDelegate(_ selectedOption: BasicTableCellModel) {
        updateSettingsDelegate(selectedOption)
        updateFileGroupDelegate(selectedOption)
    }

    private func updateSettingsDelegate(_ selectedOption: BasicTableCellModel) {
        guard let settingsDelegate else { return }
        settingsDelegate.didSelect(option: selectedOption)
    }

    private func updateFileGroupDelegate(_ selectedOption: BasicTableCellModel) {
        guard let fileGroupDelegate else { return }
        fileGroupDelegate.didSelect(group: selectedOption)
    }
}
