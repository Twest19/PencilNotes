//
//  NotesCanvasView.swift
//  FinalProject
//
//  Created by Tim West on 3/10/25.
//

import PencilKit

class NotesCanvasView: PKCanvasView {

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureDefaultCanvas()
    }

    init(frame: CGRect, drawingPolicy: PKCanvasViewDrawingPolicy) {
        super.init(frame: .zero)
        configureDefaultCanvas(drawingPolicy: drawingPolicy)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureDefaultCanvas(drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly) {
        drawing = PKDrawing()
        self.drawingPolicy = drawingPolicy
        backgroundColor = .clear
        isOpaque = false
    }

    public func setUpConstraints(in view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    public func setDrawingPolicy(_ drawingPolicy: PKCanvasViewDrawingPolicy) {
        self.drawingPolicy = drawingPolicy
    }

    public func setCanvasColor(from theme: CanvasTheme, importedPDF: Bool) {
        guard !importedPDF else { return }
        backgroundColor = theme.backgroundColor
    }
}
