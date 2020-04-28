//
//  AlertView.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct AlertView: View {
    @ObservedObject var title: ObservableString
    @ObservedObject var message: ObservableString
    @ObservedObject var primaryAlertAction: ObservableAlertAction
    @ObservedObject var secondaryAlertAction: ObservableAlertAction
    @ObservedObject var isPresented: ObservableBool
    
    var body: some View {
        VStack {
            EmptyView()
        }
        .alert(isPresented: $isPresented.bool) {
            if let primaryAlertAction = primaryAlertAction.alertAction, let secondaryAlertAction = secondaryAlertAction.alertAction {
                let primaryButton: Alert.Button = button(for: primaryAlertAction)
                let secondaryButton: Alert.Button = button(for: secondaryAlertAction)
                return Alert(title: Text(title.string), message: Text(message.string), primaryButton: primaryButton, secondaryButton: secondaryButton)
            } else if let primaryAlertAction = primaryAlertAction.alertAction {
                let primaryButton: Alert.Button = button(for: primaryAlertAction)
                return Alert(title: Text(title.string), message: Text(message.string), dismissButton: primaryButton)
            } else {
                let primaryButton = Alert.Button.default(Text("OK"))
                return Alert(title: Text(title.string), message: Text(message.string), dismissButton: primaryButton)
            }
        }
    }
    
    func button(for alertAction: AlertAction) -> Alert.Button {
        switch alertAction.style {
        case .regular:
            return Alert.Button.default(Text(alertAction.title), action: {
                DispatchQueue.main.async {
                    alertAction.action?()
                }
            })
        case .cancel:
            return Alert.Button.cancel(Text(alertAction.title), action: {
                DispatchQueue.main.async {
                    alertAction.action?()
                }
            })
        case .destructive:
            return Alert.Button.destructive(Text(alertAction.title), action: {
                DispatchQueue.main.async {
                    alertAction.action?()
                }
            })
        }
    }
}