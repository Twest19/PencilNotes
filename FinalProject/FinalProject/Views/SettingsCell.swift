//
//  SettingsCell.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let reuseID = "SettingsCell"
    static let cellPadding: CGFloat = 5

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var groupSymbol: FileGroupColor = {
        let imageView = FileGroupColor(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCell(_ cellModel: BasicTableCellModel) {
        if let group = cellModel.group {
            titleLabel.text = group.rawValue
            groupSymbol.set(using: group)
        }
        else if let setting = cellModel.settingsOption {
            titleLabel.text = setting.rawValue
        } else if let title = cellModel.title {
            titleLabel.text = title
        }
    }

    private func configure() {
        contentView.addSubview(groupSymbol)
        contentView.addSubview(titleLabel)

        // Group Symbol Constraints
        NSLayoutConstraint.activate([
            groupSymbol.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.cellPadding),
            groupSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            groupSymbol.heightAnchor.constraint(equalToConstant: 14),
            groupSymbol.widthAnchor.constraint(equalToConstant: 14)
        ])

        // Title Label Constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: groupSymbol.trailingAnchor, constant: Self.cellPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.cellPadding),
            titleLabel.centerYAnchor.constraint(equalTo: groupSymbol.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
