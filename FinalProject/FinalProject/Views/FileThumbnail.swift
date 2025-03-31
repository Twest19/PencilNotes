//
//  FileThumbnail.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit

class FileThumbnail: UIImageView {

    let placeHolder = Images.thumbnailPlaceHolder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private Methods -
private extension FileThumbnail {
    func configure() {
        layer.cornerRadius = 8
        tintColor = .systemCyan
        clipsToBounds = true
        image = placeHolder
        translatesAutoresizingMaskIntoConstraints = false
    }
}
