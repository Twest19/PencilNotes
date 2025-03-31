//
//  CanvasVC+UIDocumentPickerDelegate.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

extension CanvasVC: UIDocumentPickerDelegate {
    func presentDocumentsPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false

        present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }

        // We should make sure we have been granted access, however, it appears it is not required
        _ = selectedFileURL.startAccessingSecurityScopedResource()

        defer { selectedFileURL.stopAccessingSecurityScopedResource() }

        if let selectedDocument = PDFDocument(url: selectedFileURL) {
            let copyResultSuccess = persistenceManager.copyToLocalAppDirectory(selectedFileURL,
                                                                               drawingModel: drawingModel)
            if copyResultSuccess {
                pdfView.document = selectedDocument
            }
            else {
                let alert = Helper.createBasicAlert(title: "Error!",
                                                    message: "Could not create a Local PDF Copy. Try selecting the document again.")
                present(alert, animated: true)
            }
        }
    }
}
