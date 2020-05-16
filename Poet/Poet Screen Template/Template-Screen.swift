//
//  Template-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct Template {}

extension Template {
    struct Screen: View {
        
        let _evaluator: Evaluator
        weak var evaluator: Evaluator?
        let translator: Translator
        
        init() {
            _evaluator = Evaluator()
            evaluator = _evaluator
            translator = _evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            ZStack {
                
                VStack {
                    ObservingTextView(translator.title)
                        .font(Font.headline)
                        .fixedSize(horizontal: false, vertical: true)

                    ObservingTextView(translator.body)
                        .font(Font.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(EdgeInsets(top: 30, leading: 50, bottom: 50, trailing: 50))
                }
                
                VStack {
                    DismissButton()
                    Spacer()
                }
            }.onAppear {
                self.evaluator?.viewDidAppear()
                self.navBarHidden = true
            }
                
            // MARK: Hide Navigation Bar
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = true
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(self.navBarHidden)
        }
    }
}
