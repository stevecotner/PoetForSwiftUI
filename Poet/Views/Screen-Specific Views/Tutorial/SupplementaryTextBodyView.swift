//
//  SupplementaryTextBodyView.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/21/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct SupplementaryTextBodyView: View {
    @ObservedObject var title: ObservableString
    @ObservedObject var bodyElements: ObservableArray<Tutorial.Evaluator.Page.Body>
    
    let backgroundColor = Color(UIColor(red: 31/255.0, green: 32/255.0, blue: 38/255.0, alpha: 1))
    let barColor = Color(UIColor(red: 37/255.0, green: 40/255.0, blue: 47/255.0, alpha: 0.98))
    
    var body: some View {
        ZStack {
            VStack {
                DismissButton(foregroundColor: Color.white)
                Spacer()
            }.background(Color.clear)
            .zIndex(2)
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer().frame(height:26)
                        ForEach(self.bodyElements.array, id: \.id) { bodyElement in
                            HStack {
                                self.viewForBodyElement(bodyElement)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 16))
                        Spacer()
                    }
                }
            }.background(Rectangle().fill(
                backgroundColor
            )).zIndex(0)
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    func viewForBodyElement(_ bodyElement: Tutorial.Evaluator.Page.Body) -> AnyView {
        switch bodyElement {
        case .text(let text):
            return AnyView(
                Text(text)
                    .font(Font.system(size: 16, weight: .medium))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 14)
            )
        case .code(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 12.5, weight: .medium, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: -15))
            )
            
        case .smallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 11.5, weight: .medium, design: .monospaced))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: -20))
            )
            
        case .extraSmallCode(let code):
            return AnyView(
                Text(code)
                    .font(Font.system(size: 10.5, weight: .medium, design: .monospaced))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: -20))
            )
        }
    }
}