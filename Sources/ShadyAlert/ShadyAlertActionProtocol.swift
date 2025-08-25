//
//  ShadyAlertActionProtocol.swift
//  ShadyAlertExample
//
//  Created by John Shade on 22/08/25.
//


import Foundation
import SwiftUI

// MARK: - Alert Action Protocol
public protocol ShadyAlertActionProtocol: Identifiable, Hashable, CaseIterable {
    var id: UUID { get }
    var title: String { get }
    var role: ButtonRole? { get }
}
