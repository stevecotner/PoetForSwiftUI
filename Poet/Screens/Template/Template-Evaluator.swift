//
//  Template-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Template {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current State
        var current = PassableState(State.initial)
    }
}

// State

extension Template.Evaluator {
    enum State: EvaluatorState {
        case initial
        case text(TextState)
    }
    
    struct TextState {
        var title: String
        var body: String
    }
}

// View Cycle

extension Template.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showText()
    }
    
    func showText() {
        let state = TextState(
            title: "Template",
            body:
            """
            You're looking at a screen made with a simple template, located in Template-Screen.swift.

            Use this template as the basis for new screens, or read through its code to get a better sense of the Poet pattern.
            """
        )
        current.state = .text(state)
    }
}
