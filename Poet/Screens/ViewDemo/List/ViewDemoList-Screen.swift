//
//  ViewDemoList-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import SwiftUI

struct ViewDemoList {}

extension ViewDemoList {
    
    struct Screen: View {
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        var body: some View {
            return ZStack {
                ViewDemoListView(demoProviders: translator.demoProviders, evaluator: evaluator)
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
                
                PresenterWithPassedValue(translator.showDemo, evaluator: evaluator) { provider in
                    return ViewDemoDetail(namedDemoProvider: provider)
                }
                
                Presenter(translator.showDemoBuilder) {
                    return DemoBuilder.Screen()
                }
            }
            .onAppear {
                self.evaluator.viewDidAppear()
            }
        }
    }
}
