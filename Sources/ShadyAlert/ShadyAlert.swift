//
//  ShadyAlertData.swift
//  ShadyAlertExample
//
//  Created by John Shade on 22/08/25.
//

import SwiftUI

// MARK: - Alert Data
public struct ShadyAlert: Identifiable {
    
    public static func withError(_ error: any Error, title: String? = nil) -> ShadyAlert {
        return ShadyAlert(type: .error, title: title ?? "Error", message: error.localizedDescription)
    }
    
    public let id: UUID
    
    public enum AlertType {
        case error
        case info
        case actionAlert
    }
    
    public let type: AlertType
    public let customTitle: String?
    public let message: String?
    public let actions: [any ShadyAlertActionProtocol]
    
    public init(
            id: UUID = UUID(),
            type: AlertType,
            title: String? = nil,
            message: String? = nil,
            actions: [any ShadyAlertActionProtocol] = []) {
        
        self.id = id
        self.type = type
        self.customTitle = title
        self.message = message
        self.actions = actions
    }
    
    public var alertTitle: String {
        if let customTitle = customTitle {
            return customTitle
        }
        
        switch type {
        case .error:
            return "Error"
        case .info:
            return "Info"
        case .actionAlert:
            return ""
        }
    }
}
