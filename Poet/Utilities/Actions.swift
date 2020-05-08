//
//  Typealiases.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/25/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import Foundation

typealias Behavior = AnyCancellable
typealias Action = (() -> Void)?

extension Action {
    func evaluate() {
        self?()
    }
}

struct NamedAction {
    let name: String
    let action: Action
}

struct NamedEvaluatorAction {
    let name: String
    let action: EvaluatorAction
    var id: UUID = UUID()
}
