//
//  CanvasVC.swift
//  FinalProject
//
//  Created by Tim West on 3/10/25.
//

import UIKit
import PencilKit
import PDFKit

class CanvasVC: UIViewController, PKToolPickerObserver, PDFViewDelegate, PKCanvasViewDelegate {

    // MARK: Views
    var pdfView: MyPDFView!
    var backBTNView: BasicNotesBTN!
    var canvasSettingsBTNView: BasicNotesBTN!

    // MARK: Variables
    let persistenceManager = PersistenceManager.shared
    let globalSettings = GlobalDrawingSettingsModel.shared
    var toolPicker = PKToolPicker()
    var drawingModel: DrawingModelDTO

    var pageToViewMapping = [PDFPage: PKDrawing]()
    var currentPage: PDFPage?
    var currentCanvas: NotesCanvasView?

    init(drawingModel: DrawingModelDTO) {
        self.drawingModel = drawingModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attemptLoadSavedCanvas()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentPage, let currentCanvas {
            // Must save canvas currently on screen as
            // `willEndDisplayingOverlayView` may not be called
            pageToViewMapping[currentPage] = currentCanvas.drawing
        }
        saveCanvasChanges()
    }

    @MainActor
    private func saveCanvasChanges() {
        guard let currentDrawingId = drawingModel.id else { return }

        // Save Blank PDF to File manager
        if !drawingModel.hasPDF,
           let document = pdfView.document,
           let pdfFileName = drawingModel.pdfFileName {
            let saveResult = persistenceManager.saveData(document.dataRepresentation(), to: pdfFileName)
            drawingModel.hasPDF = saveResult
        }

        var pageCount: Int16 = 0

        // Go through PDFView map and save the drawings
        for i in 0..<(pdfView.document?.pageCount ?? 0) {
            guard let page = pdfView.document?.page(at: i) else { continue }

            var drawingData: Data?
            if let pageDrawing = pageToViewMapping[page] {
                drawingData = pageDrawing.dataRepresentation()
            }

            // Save the drawing data
            if let data = drawingData,
               let pageName = drawingModel.getFileName(for: Int16(i), addExtension: true) {
                PersistenceManager.shared.saveData(data, to: pageName)
                pageCount += 1
            }
        }

        drawingModel.lastEditedTime = Date()
        drawingModel.pageCount = pageCount

        // Check if entry in CoreData if not, create one
        if let existingDrawing = PersistenceManager.shared.fetchExistingDrawing(for: currentDrawingId) {
            persistenceManager.updateDrawing(existingDrawing, drawingModel)
        }
        else {
            persistenceManager.createNewCDDrawing(drawingModel)
        }
    }

    @MainActor
    private func attemptLoadSavedCanvas() {
        var document: PDFDocument?
        
        if let pdfFileName = drawingModel.pdfFileName,
           let pdfURL = persistenceManager.createURL(for: pdfFileName) {
            document = PDFDocument(url: pdfURL)
        }

        if document == nil {
            // Something went wrong above or this is a fresh document no pdf imported
            // Just create 1 blank pdf page
            document = PDFDocument(data: Helper.createBlankPDFDocument())
        }

        // Need to populate [PDFPage: PKDrawing]() map
        if let document {
            for i in 0..<document.pageCount {
                guard let page = document.page(at: i) else { continue }

                // Find corresponding drawing.dat file saved in file manager
                if let drawingFileName = drawingModel.getFileName(for: Int16(i), addExtension: true),
                   let drawingData = persistenceManager.loadData(with: drawingFileName) {
                    do {
                        let previousDrawing = try PKDrawing(data: drawingData)
                        pageToViewMapping[page] = previousDrawing
                    }
                    catch {
                        print("⚠️ Error Loading Drawing for page #\(i): \(error) ⚠️")
                    }
                }

                // There was an issue re-creating drawing (may not have existed),
                // just add a blank PKDrawing
                if pageToViewMapping[page] == nil {
                    pageToViewMapping[page] = PKDrawing()
                }
            }
        }

        pdfView.document = document
    }
}

// MARK: Configuration
extension CanvasVC {
    private func configure() {
        configurePDFView()
        configureToolPicker()
        configureBackButton()
        configureCanvasSettingsButton()
    }

    private func configurePDFView() {
        pdfView = MyPDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.displayBox = .mediaBox
        pdfView.usePageViewController(true)
        pdfView.isInMarkupMode = true
        view.addSubview(pdfView)

        pdfView.delegate = self
        pdfView.pageOverlayViewProvider = self
    }

    private func configureToolPicker() {
        toolPicker.selectedTool = globalSettings.getDefaultTool()
        toolPicker.showsDrawingPolicyControls = false
        toolPicker.addObserver(pdfView)
        toolPicker.addObserver(self)
        toolPicker.setVisible(true, forFirstResponder: pdfView)
        pdfView.becomeFirstResponder()
    }

    private func configureBackButton() {
        let backBTN = BasicNotesBTN(color: .systemRed, title: "Back", systemImage: "arrow.left")
        backBTN.configuration?.buttonSize = .medium
        backBTN.addTarget(self, action: #selector(backBTNAction), for: .touchUpInside)
        backBTNView = backBTN
        view.addSubview(backBTNView)

        NSLayoutConstraint.activate([
            backBTN.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backBTN.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }

    private func configureCanvasSettingsButton() {
        let settingsBTN = BasicNotesBTN(color: .systemGreen, systemImage: "gear")
        settingsBTN.configuration?.buttonSize = .large
        settingsBTN.addTarget(self, action: #selector(settingsBTNAction), for: .touchUpInside)
        canvasSettingsBTNView = settingsBTN
        view.addSubview(canvasSettingsBTNView)

        NSLayoutConstraint.activate([
            settingsBTN.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsBTN.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
}

// MARK: UIAction + BTN Action
extension CanvasVC {
    private func editNameUIAction() -> UIAction {
        let editNameAction = UIAction(title: "Edit Name") { [weak self] action in
            guard let self else { return }
            let alertController = UIAlertController(title: "Edit Name", message: nil, preferredStyle: .alert)

            alertController.addTextField { textField in
                textField.placeholder = "Enter new name"
                textField.text = self.drawingModel.drawingName
                textField.clearsOnBeginEditing = true
            }

            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self]_ in
                if let newName = alertController.textFields?.first?.text, !newName.isEmpty {
                    self?.drawingModel.drawingName = newName
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true)
        }

        return editNameAction
    }

    func importPDFUIAction() -> UIAction {
        let importPDFAction = UIAction(title: "Import PDF") { [weak self] action in
            self?.presentDocumentsPicker()
        }

        return importPDFAction
    }

    @objc
    private func backBTNAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func settingsBTNAction(_ sender: UIButton) {
        var children: [UIMenuElement] = [editNameUIAction()]

        if !drawingModel.hasPDF {
            children.append(importPDFUIAction())
        }

        let menu = UIMenu(title: "Canvas Settings", children: children)

        sender.showsMenuAsPrimaryAction = true
        sender.menu = menu
    }
}
