//
//  NotesBTN.swift
//  FinalProject
//
//  Created by Tim West on 3/10/25.
//

import UIKit

class BasicNotesBTN: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(color: UIColor, title: String? = nil, systemImage: String? = nil) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImage: systemImage)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configuration = .tinted()
        configuration?.cornerStyle = .capsule
    }

    public func set(color: UIColor, title: String?, systemImage: String?) {
        configureImage(systemImage: systemImage)
        configuration?.title = title
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
    }

    private func configureImage(systemImage: String?) {
        guard let systemImage else {
            configuration?.image = nil
            return
        }

        let image = UIImage(systemName: systemImage)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: SFSymbolSizing.medium)
        configuration?.image = image
        configuration?.preferredSymbolConfigurationForImage = symbolConfig
        configuration?.imagePadding = 5
    }
}
