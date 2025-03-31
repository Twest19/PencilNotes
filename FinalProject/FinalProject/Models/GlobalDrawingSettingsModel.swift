//
//  GlobalDrawingSettingsModel.swift
//  FinalProject
//
//  Created by Tim West on 3/13/25.
//

import PencilKit
import UIKit

class GlobalDrawingSettingsModel {

    static let shared = GlobalDrawingSettingsModel()

    private init() { }

    private enum UDKeys {
        static let canvasThemeColor = "settings.canvasThemeColor"
        static let drawingPolicy = "settings.drawingPolicy"
        static let pkTool = "settings.myDefaultTool"
        static let fdAlert = "settings.fdAlert"
    }

    // MARK: Canvas Preferences
    var drawingPolicy: PKCanvasViewDrawingPolicy {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: UDKeys.drawingPolicy)
            return PKCanvasViewDrawingPolicy(rawValue: UInt(rawValue)) ?? .anyInput
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UDKeys.drawingPolicy)
        }
    }

    var canvasTheme: CanvasTheme {
        get {
            let rawValue = UserDefaults.standard.string(forKey: UDKeys.canvasThemeColor)
            return CanvasTheme(rawValue: rawValue ?? "default") ?? .default
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UDKeys.canvasThemeColor)
        }
    }

    var hasPresentedFingerDrawingAlert: Bool {
        get {
            UserDefaults.standard.bool(forKey: UDKeys.fdAlert)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UDKeys.fdAlert)
        }
    }

    // MARK: Tool Preferences
    var defaultTool: MyPKTool {
        get {
            let rawValue = UserDefaults.standard.string(forKey: UDKeys.pkTool)
            return MyPKTool(rawValue: rawValue ?? "Pen") ?? .pen
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UDKeys.pkTool)
        }
    }

    func getDefaultTool() -> PKTool {
        switch defaultTool {
            case .pen:
                PKInkingTool(.pen, color: .systemBlue)
            case .pencil:
                PKInkingTool(.pencil, color: .systemBlue)
            case .marker:
                PKInkingTool(.marker, color: .systemBlue)
            case .crayon:
                PKInkingTool(.crayon, color: .systemBlue)
            case .fountainPen:
                PKInkingTool(.fountainPen, color: .systemBlue)
            case .waterColor:
                PKInkingTool(.watercolor, color: .systemBlue)
        }
    }
}
