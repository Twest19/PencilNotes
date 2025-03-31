//
//  Helper.swift
//  FinalProject
//
//  Created by Tim West on 3/9/25.
//

import UIKit

enum Helper {
    static func collectionViewLayout(in view: UIView, with columnNumber: CGFloat = 3) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 10
        let minimumItemSpacing: CGFloat = 20
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / columnNumber

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: 250)

        return flowLayout
    }

    // Resource from: https://www.kodeco.com/4023941-creating-a-pdf-in-swift-with-pdfkit#toc-anchor-002
    static func createBlankPDFDocument() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "TW-CSC371-FinalProject"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            let text = ""
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }

        return data
    }

    static func createBasicAlert(title: String?,
                                 message: String?,
                                 preferredStyle: UIAlertController.Style = .alert,
                                 actionText: String = "OK",
                                 actionStyle:  UIAlertAction.Style = .default,
                                 actionHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let basicErrorAlert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        basicErrorAlert.addAction(UIAlertAction(title: actionText, style: actionStyle, handler: actionHandler))
        return basicErrorAlert
    }
}
