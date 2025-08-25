//
//  View+.swift
//  ShadyAlertExample
//
//  Created by John Shade on 22/08/25.
//
import SwiftUI

// MARK: - View Extension
extension View {
    public func shadyAlert(
        item: Binding<ShadyAlert?>,
        onAction: ((any ShadyAlertActionProtocol) -> Void)? = nil
    ) -> some View {
        self.modifier(ShadyAlertModifier(alertData: item, onAction: onAction))
    }
}
