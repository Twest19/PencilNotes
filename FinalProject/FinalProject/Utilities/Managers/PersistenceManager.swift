//
//  PersistenceManager.swift
//  FinalProject
//
//  Created by Tim West on 3/11/25.
//

import Foundation
import CoreData

final class PersistenceManager {

    static let shared = PersistenceManager()
    let fileManager = FileManager.default

    var persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var defaultDirectoryURL: URL?

    private init() {
        if let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first {
            let folderURL = documentsDirectory.appendingPathComponent("MyDrawings")

            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(at: folderURL,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                    self.defaultDirectoryURL = folderURL
                } catch {
                    print("Error creating default folder: \(error)")
                }
            }
            else {
                defaultDirectoryURL = folderURL
            }
        }

        persistentContainer = NSPersistentContainer(name: "CanvasDrawingModel")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    func createURL(for fileName: String) -> URL? {
        guard let defaultDirectoryURL else { return nil }

        let fileURL = defaultDirectoryURL.appending(path: fileName)
        return fileURL
    }

    @discardableResult
    func saveData(_ data: Data, to fileName: String) -> Bool {
        guard let defaultDirectoryURL else { return false }

        do {
            let fileURL = defaultDirectoryURL.appending(path: fileName)
            try data.write(to: fileURL)
            return true
        }
        catch {
            return false
        }
    }

    @discardableResult
    func saveData(_ data: Data?, to fileName: String) -> Bool {
        guard let data else { return false }
        return saveData(data, to: fileName)
    }

    func loadData(with fileName: String) -> Data? {
        guard let defaultDirectoryURL else { return nil }

        let fileURL = defaultDirectoryURL.appending(path: fileName)

        do {
            let data = try Data(contentsOf: fileURL)
            return data
        }
        catch {
            return nil
        }
    }

    func loadData(from filePath: URL) -> Data? {
        do {
            let data = try Data(contentsOf: filePath)
            return data
        }
        catch {
            return nil
        }
    }

    func removeFile(at url: URL?) {
        guard let url else { return }
        do {
            try fileManager.removeItem(at: url)
        }
        catch {
            print("Tried to remove a file that does not exist!")
        }
    }

    func removeFile(at urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        removeFile(at: url)
    }

    @discardableResult
    func copyToLocalAppDirectory(_ selectedUrl: URL, drawingModel: DrawingModelDTO) -> Bool {
        guard let defaultDirectoryURL, let pdfFileName = drawingModel.pdfFileName else { return false }

        do {
            let localAppURL = defaultDirectoryURL.appending(path: pdfFileName)
            if fileManager.fileExists(atPath: localAppURL.path) {
                try fileManager.removeItem(at: localAppURL)
            }
            try fileManager.copyItem(at: selectedUrl, to: localAppURL)
            drawingModel.hasPDF = true
            drawingModel.importedPDF = true
            return true
        }
        catch {
            print("⚠️ Error Copying PDF to local app directory! ⚠️")
            drawingModel.hasPDF = false
            return false
        }
    }
}

// MARK: CoreData Helpers
extension PersistenceManager {
    func getAllDrawings() -> [DrawingModelDTO]? {
        do {
            let allDrawings = try context.fetch(CDDrawingModel.fetchRequest())
            return allDrawings.map { DrawingModelDTO($0) }
        }
        catch {
            print("⚠️ Error Fetching CDDrawingModels ⚠️")
            return nil
        }
    }

    func createNewCDDrawing(_ dto: DrawingModelDTO) {
        let newDrawing = CDDrawingModel(context: context)
        updateDrawing(newDrawing, dto)
    }

    func deleteDrawing(_ drawing: CDDrawingModel) {
        context.delete(drawing)
        saveCDContext()
    }

    func deleteDrawing(with id: UUID) {
        guard let storedDrawing = fetchExistingDrawing(for: id) else {
            return
        }

        deleteDrawing(storedDrawing)
    }

    func updateDrawing(_ dto: DrawingModelDTO) {
        guard let id = dto.id, let storedDrawing = fetchExistingDrawing(for: id) else {
            return
        }
        updateDrawing(storedDrawing, dto)
    }

    func updateDrawing(_ currentDrawing: CDDrawingModel, _ dto: DrawingModelDTO) {
        currentDrawing.id = dto.id
        currentDrawing.creationTime = dto.creationTime
        currentDrawing.lastEdited = dto.lastEditedTime
        currentDrawing.filename = dto.fileName
        currentDrawing.drawingName = dto.drawingName
        currentDrawing.hasPDF = dto.hasPDF
        currentDrawing.pdfFileName = dto.pdfFileName
        currentDrawing.drawingPolicy = Int16(dto.drawingPolicy.rawValue)
        currentDrawing.pageCount = dto.pageCount
        currentDrawing.group = dto.group.rawValue
        currentDrawing.importedPDF = dto.importedPDF

        saveCDContext()
    }

    func fetchExistingDrawing(for id: UUID) -> CDDrawingModel? {
        let fetchRequest: NSFetchRequest<CDDrawingModel> = CDDrawingModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let records = try context.fetch(fetchRequest)
            return records.first
        } catch {
            print("⚠️ Error fetching drawing: \(error). Drawing may not exist! ⚠️")
            return nil
        }
    }

    private func saveCDContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("⚠️ Error saving context: \(error) ⚠️")
            }
        }
    }
}
