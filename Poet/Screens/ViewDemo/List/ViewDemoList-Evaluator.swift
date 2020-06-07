//
//  ViewDemoList-Evaluator.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension ViewDemoList {
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator(current)
        
        // Current Step
        var current = PassableStep(Step.initial)
    }
}

// Steps and Step Configurations
extension ViewDemoList.Evaluator {
    enum Step: EvaluatorStep {
        case initial
        case list(ListStepConfiguration)
    }
    
    struct ListStepConfiguration {
        var demoProviders: [NamedDemoProvider]
    }
}

// View Cycle
extension ViewDemoList.Evaluator: ViewCycleEvaluating {
    func viewDidAppear() {
        showListStep()
    }
}

// Advancing Between Steps
extension ViewDemoList.Evaluator {
    func showListStep() {
        let configuration = ListStepConfiguration(
            demoProviders: [
                ObservingTextView.namedDemoProvider,
                OptionsView.namedDemoProvider,
                ProductView.namedDemoProvider
            ]
        )
        current.step = .list(configuration)
    }
}

extension ViewDemoList.Evaluator: ActionEvaluating {
    func evaluate(_ action: EvaluatorAction?) {
        guard let action = action as? DemoListAction else { return }
        
        switch action {
        case .demoProviderSelected(let provider):
            translator.showPreview.withValue(provider)
        }
    }
}

extension ViewDemoList.Evaluator: PresenterEvaluating {
    func presenterDidDismiss(elementName: EvaluatorElement?) {
        // Reinitialize all the providers
        showListStep()
    }
}
