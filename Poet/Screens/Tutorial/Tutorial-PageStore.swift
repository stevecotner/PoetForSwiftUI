//
//  Tutorial-PageStore.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/9/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation

extension Tutorial {
    class PageStore {
        
        typealias Chapter = Evaluator.Chapter
        typealias Page = Evaluator.Page
        typealias Supplement = Evaluator.Page.Supplement
        
        static let shared = PageStore()
        
        lazy var pageData: [Chapter] = [
            chapter_Introduction,
            chapter_WhyPoet,
            chapter_Template,
            chapter_InteractingWithAView,
            chapter_UpdatingState,
            chapter_BusinessStatePart2,
            chapter_AsynchronousWork,
            chapter_PassableState,
            chapter_PassableStatePart2,
            chapter_ProtocolOrientedTranslating,
            chapter_RetailDemo,
            chapter_LoginDemo,
            chapter_ANoteOnCombine
        ]
    }
}

/*
 Screen demos to make:
 * a list with an indeterminate number of sections, based on the data pulled down
 * text entry
 */
