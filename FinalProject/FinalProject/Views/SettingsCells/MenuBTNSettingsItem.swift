//
//  MenuBTNSettingsItem.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit

class MenuBTNSettingsItem: UITableViewCell {
    static let reuseID = "MENU_CELL"
    static let cellPadding: CGFloat = 5

    var onOptionSelected: ((String) -> Void)?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var menuButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(menuButton)

        // Group Symbol Constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.cellPadding),
            titleLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -Self.cellPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
        ])

        // Title Label Constraints
        NSLayoutConstraint.activate([
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.cellPadding),
            menuButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setup(with options: [String], selectedOption: String? = nil) {
        let menuActions = options.map { option in
            UIAction(title: option, state: option == selectedOption ? .on : .off) { [weak self] action in
                self?.onOptionSelected?(action.title)
            }
        }
        menuButton.menu = UIMenu(children: menuActions)
        menuButton.setTitle(selectedOption ?? options.first, for: .normal)
    }
}
