//
//  Menu-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/24/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Foundation
import SwiftUI

extension Menu {
    class Evaluator {
        
        // Translator
        
        lazy var translator: Translator = Translator(items)
        
        // Data
        
        var items = PassableArray<MenuListItem>()
    }
}

// MARK: View Cycle

extension Menu.Evaluator: ViewCycleEvaluating {
    
    func viewDidAppear() {
        typealias Link = Menu.Link
        typealias Title = Menu.Title
        
        items.array = [
            Link("Introduction",
                 destination: { AnyView(About.Screen()) }),
            
            Link("Why Poet?",
                 destination: { AnyView(Tutorial.Screen()) }),
            
//            Title("Retail Example"),
            
            Link("Retail Demo",
                 destination: { AnyView(Retail.Screen()) }),
            
//            Link("Observable Page View Tutorial",
//                 destination: { AnyView(Text("Coming soon...")) }),
            
//            Title("Checklist Example"),
            
//            Link("Checklist Demo",
//                 destination: { AnyView(Text("Coming soon...")) }),
            
//            Link("Checklist Tutorial",
//                 destination: { AnyView(Text("Coming soon...")) }),
            
//            Title("Little Helpers"),
            
            Link("Dismiss Receiver",
                 destination: { AnyView(DismissReceiverExample.Screen()) }),
            
            Link("Template",
                destination: { AnyView(Template.Screen()) })
        ]
    }
}
