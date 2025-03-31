//
//  CanvasFileCell.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit

class CanvasFileCell: UICollectionViewCell {

    var thumbnail = FileThumbnail(frame: .zero)
    var groupColor = FileGroupColor(frame: .zero)
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    lazy var timeStamp: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    static let identifier = "CANVASFILECELL"

    private let outerPadding: CGFloat = 5

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCell(with drawingModel: DrawingModelDTO) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: drawingModel.lastEditedTime ?? .now)
        timeStamp.text = dateString
        nameLabel.text = drawingModel.drawingName
        thumbnail.image = UIImage(systemName: "scribble.variable")
        if drawingModel.group.color != .clear {
            thumbnail.tintColor = drawingModel.group.color
        }
        else {
            thumbnail.tintColor = .systemCyan
        }
        groupColor.set(using: drawingModel.group)
    }

    private func configureCell() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.addSubview(thumbnail)
        contentView.addSubview(nameLabel)
        contentView.addSubview(groupColor)
        contentView.addSubview(timeStamp)
        addConstraints()
    }

    private func addConstraints() {
        groupColor.translatesAutoresizingMaskIntoConstraints = false

        // Time Stamp
        NSLayoutConstraint.activate([
            timeStamp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -outerPadding),
            timeStamp.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: outerPadding),
            timeStamp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -outerPadding),
            timeStamp.heightAnchor.constraint(equalToConstant: 30),
        ])

        // Name
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: timeStamp.topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: outerPadding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -outerPadding),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Image
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            thumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            thumbnail.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: outerPadding)
        ])

        // Status
        NSLayoutConstraint.activate([
            groupColor.topAnchor.constraint(equalTo: contentView.topAnchor, constant: outerPadding),
            groupColor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: outerPadding),
            groupColor.heightAnchor.constraint(equalToConstant: 14),
            groupColor.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
}
