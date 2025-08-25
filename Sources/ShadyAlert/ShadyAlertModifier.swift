//
//  ShadyAlertModifier.swift
//  ShadyAlertExample
//
//  Created by John Shade on 22/08/25.
//

import SwiftUI

// MARK: - View Modifier
public struct ShadyAlertModifier: ViewModifier {
    @Binding private var alertData: ShadyAlert?
    
    private let onAction: ((any ShadyAlertActionProtocol) -> Void)?
    
    public init(alertData: Binding<ShadyAlert?>, onAction: ((any ShadyAlertActionProtocol) -> Void)? = nil) {
        self._alertData = alertData
        self.onAction = onAction
    }
    
    // Computed property to convert optional alertData to Bool for isPresented
    private var isPresented: Binding<Bool> {
        Binding<Bool>(
            get: { alertData != nil },
            set: { newValue in
                if !newValue {
                    alertData = nil
                }
            }
        )
    }
    
    public func body(content: Content) -> some View {
        content
            .alert(
                alertData?.alertTitle ?? "",
                isPresented: isPresented,
                actions: {
                    if let data = alertData {
                        if data.actions.isEmpty {
                            // Default OK button for alerts without actions
                            Button("Ok") {
                                alertData = nil
                            }
                        } else {
                            // Generate buttons for all actions
                            ForEach(data.actions, id: \.id) { action in
                                Button(role: action.role) {
                                    alertData = nil
                                    onAction?(action)
                                } label: {
                                    let txt = Text(action.title)
                                    if action.role == .destructive {
                                        txt
                                            .bold()
                                    } else {
                                        txt
                                    }
                                }
                            }
                        }
                    }
                },
                message: {
                    if let message = alertData?.message {
                        Text(message)
                    }
                }
            )
    }
}
