//
//  CanvasCollectionView.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit

class CanvasCollectionView: UICollectionView {
    init(in view: UIView) {
        let flowLayoutHelper = Helper.collectionViewLayout(in: view, with: 3)
        super.init(frame: view.bounds, collectionViewLayout: flowLayoutHelper)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        registerCanvasFileCell()
    }

    func registerCanvasFileCell() {
        register(CanvasFileCell.self, forCellWithReuseIdentifier: CanvasFileCell.identifier)
    }

    func setUpConstraints(in view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
