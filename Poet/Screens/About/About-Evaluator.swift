//
//  About-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension About {
    class Evaluator {
        
        // Translator
        
        let translator: Translator = Translator()
        
        // Data
        
        private var page: StaticPage = AboutDataStore.shared.page
    }
}

// MARK: View Cycle

extension About.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        translator.show(page: page) // <-- quick and dirty. not real state-based Poet
    }
}
