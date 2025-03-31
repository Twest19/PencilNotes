//
//  DrawingModelDTO.swift
//  FinalProject
//
//  Created by Tim West on 3/11/25.
//

import Foundation
import PencilKit

class DrawingModelDTO: Identifiable {
    private(set) var id: UUID?
    private(set) var creationTime: Date?
    private(set) var fileName: String?
    private(set) var pdfFileName: String?

    var drawingName: String?
    var lastEditedTime: Date?
    var drawingPolicy: PKCanvasViewDrawingPolicy = .pencilOnly
    var pageCount: Int16 = 1
    var hasPDF: Bool = false
    var importedPDF: Bool = false
    var group: FileGroupOption = .none

    init(id: UUID?,
         creationTime: Date?,
         lastEditedTime: Date?,
         fileName: String?,
         pdfFileName: String?,
         drawingName: String?,
         hasPDF: Bool = false,
         importedPDF: Bool = false,
         group: FileGroupOption = .none,
         drawingPolicy: UInt,
         pageCount: Int16) {
        self.id = id
        self.creationTime = creationTime
        self.lastEditedTime = lastEditedTime
        self.fileName = fileName
        self.pdfFileName = pdfFileName
        self.drawingName = drawingName
        self.hasPDF = hasPDF
        self.group = group
        self.importedPDF = importedPDF
        self.drawingPolicy = PKCanvasViewDrawingPolicy(rawValue: drawingPolicy) ?? .pencilOnly
        self.pageCount = pageCount
    }

    convenience init() {
        let creationTime = Date()
        let defaultDrawingName = "Drawing_\(Date.getFormattedCreationTime(creationTime))"
        let defaultFileName = "\(defaultDrawingName)_page_"
        let defaultPDFFileName = "\(defaultDrawingName).pdf"
        let defaultPageCount: Int16 = 1
        self.init(id: UUID(),
                  creationTime: creationTime,
                  lastEditedTime: creationTime,
                  fileName: defaultFileName,
                  pdfFileName: defaultPDFFileName,
                  drawingName: defaultDrawingName,
                  drawingPolicy: PKCanvasViewDrawingPolicy.pencilOnly.rawValue,
                  pageCount: defaultPageCount
        )
    }

    convenience init(_ drawingModel: CDDrawingModel) {
        self.init(
            id: drawingModel.id,
            creationTime: drawingModel.creationTime,
            lastEditedTime: drawingModel.lastEdited,
            fileName: drawingModel.filename,
            pdfFileName: drawingModel.pdfFileName,
            drawingName: drawingModel.drawingName,
            hasPDF: drawingModel.hasPDF,
            importedPDF: drawingModel.importedPDF, 
            group: FileGroupOption(rawValue: drawingModel.group ?? "None") ?? .none,
            drawingPolicy: UInt(drawingModel.drawingPolicy),
            pageCount: drawingModel.pageCount
        )
    }

    func getFileName(for page: Int16, addExtension: Bool = false) -> String? {
        guard let fileName else { return nil }
        var fileNameForPage = "\(fileName)\(page)"
        if addExtension {
            fileNameForPage = "\(fileNameForPage).dat"
        }
        return fileNameForPage
    }
}
