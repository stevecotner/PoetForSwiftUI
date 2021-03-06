//
//  DismissButton.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let orientation: Orientation
    let foregroundColor: Color?

    enum Orientation {
        case left
        case right
        case none
    }
    
    init(orientation: Orientation, foregroundColor: Color? = nil) {
        self.orientation = orientation
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        HStack {
            if orientation == .right {
                Spacer()
            }
            Button(
                action: {
                    self.presentationMode.wrappedValue.dismiss()
            })
            {
                Image(systemName: "xmark")
                    .foregroundColor(foregroundColor ?? Color.primary)
                    .padding(EdgeInsets(top: 26, leading: 14, bottom: 10, trailing: 26))
                    .font(Font.system(size: 18, weight: .regular))
            }
            if orientation == .left {
                Spacer()
            }
        }
    }
    
}
