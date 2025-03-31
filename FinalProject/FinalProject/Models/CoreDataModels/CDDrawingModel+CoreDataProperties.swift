//
//  CDDrawingModel+CoreDataProperties.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//
//

import Foundation
import CoreData


extension CDDrawingModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDrawingModel> {
        return NSFetchRequest<CDDrawingModel>(entityName: "CDDrawingModel")
    }

    @NSManaged public var filename: String?
    @NSManaged public var id: UUID?
    @NSManaged public var creationTime: Date?
    @NSManaged public var lastEdited: Date?
    @NSManaged public var drawingName: String?
    @NSManaged public var pdfFileName: String?
    @NSManaged public var drawingPolicy: Int16
    @NSManaged public var pageCount: Int16
    @NSManaged public var hasPDF: Bool
    @NSManaged public var importedPDF: Bool
    @NSManaged public var group: String?

}

extension CDDrawingModel : Identifiable {

}
