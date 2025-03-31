//
//  CanvasVC+PDFPageOverlayViewProvider.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit
import PDFKit

extension CanvasVC: PDFPageOverlayViewProvider {
    func pdfView(_ view: PDFView, overlayViewFor page: PDFPage) -> UIView? {
        var resultView: NotesCanvasView? = nil
        resultView = NotesCanvasView(frame: .zero, drawingPolicy: globalSettings.drawingPolicy)
        resultView?.setCanvasColor(from: globalSettings.canvasTheme, importedPDF: drawingModel.importedPDF)
        currentPage = page
        if let pageDrawing = pageToViewMapping[page] {
            resultView?.drawing = pageDrawing
        }

        currentCanvas = resultView
        return currentCanvas
    }

    func pdfView(_ pdfView: PDFView, willDisplayOverlayView overlayView: UIView, for page: PDFPage) {
        if let overlayView = overlayView as? NotesCanvasView {
            toolPicker.addObserver(overlayView)
            overlayView.delegate = self
        }
    }

    func pdfView(_ pdfView: PDFView, willEndDisplayingOverlayView overlayView: UIView, for page: PDFPage) {
        if let overlayView = overlayView as? NotesCanvasView {
            pageToViewMapping[page] = overlayView.drawing
            toolPicker.removeObserver(overlayView)
        }
    }
}
