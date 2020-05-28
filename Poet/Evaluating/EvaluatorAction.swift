//
//  EvaluatorAction.swift
//  Poet
//
//  Created by Stephen E. Cotner on 5/16/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

protocol EvaluatorAction {}

protocol EvaluatorActionWithName: EvaluatorAction {
    var name: String { get }
}

protocol EvaluatorActionWithIcon: EvaluatorAction {
    var icon: String { get }
}

protocol EvaluatorActionWithIconAndID: EvaluatorActionWithIcon {
    var id: String { get }
}
