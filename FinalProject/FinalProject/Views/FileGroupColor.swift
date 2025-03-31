//
//  FileGroupColor.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit

class FileGroupColor: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        image = nil
        tintColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(using group: FileGroupOption) {
        image = SFSymbols.circle
        tintColor = group.color
    }
}

enum GroupShape: CaseIterable {
    case triangle
    case circle
    case rectangle
    case square

    var sfSymbol: UIImage? {
        switch self {
            case .triangle:
                SFSymbols.triangle
            case .circle:
                SFSymbols.circle
            case .rectangle:
                SFSymbols.rectangle
            case .square:
                SFSymbols.square
        }
    }
}
