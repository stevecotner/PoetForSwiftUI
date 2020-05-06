//
//  RetailTutorial-PageViewMaker.swift
//  Poet
//
//  Created by Stephen E Cotner on 5/1/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

protocol FindingProductsEvaluator: class {
    func toggleProductFound(_ product: FindableProduct)
    func toggleProductNotFound(_ product: FindableProduct)
}

protocol OptionsEvaluator: class {
    func toggleOption(_ option: String)
}

extension RetailTutorial {
    struct PageViewMaker: ObservingPageView_ViewMaker {
        var title: ObservableString
        var details: ObservableString
        var instruction: ObservableString
        var instructionNumber: ObservableInt
        var products: ObservableArray<Product>
        var findableProducts: ObservableArray<FindableProduct>
        var deliveryOptions: ObservableArray<String>
        var deliveryPreference: ObservableString
        var completedSummary: ObservableString
        var findingProductsEvaluator: FindingProductsEvaluator?
        var optionsEvaluator: OptionsEvaluator?

        func view(for section: ObservingPageSection) -> AnyView {
            guard let section = section as? RetailTutorial.Page.Section else {
                return AnyView(EmptyView())
            }
            
            switch section {
                
            case .title:
                return AnyView(
                    ObservingTextView(title)
                        .font(Font.system(size: 32, weight: .bold))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 80))
                )
                
            case .details:
                return AnyView(
                    ObservingTextView(details)
                        .font(Font.system(.headline).monospacedDigit())
                        .opacity(0.33)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 18, trailing: 20))
                )
                
            case .instruction:
                return AnyView(
                    InstructionView(instructionNumber: instructionNumber, instruction: instruction)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 18, trailing: 20))
                )
             
            case .products:
                return AnyView(
                    ProductsView(products: products)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )
                
            case .findableProducts:
                return AnyView(
                    FindableProductsView(findableProducts: findableProducts, evaluator: self.findingProductsEvaluator)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )
                
            case .deliveryOptions:
                return AnyView(
                    OptionsView(options: deliveryOptions, preference: deliveryPreference, evaluator: self.optionsEvaluator)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                )
                
            case .completedSummary:
                return AnyView(
                    ObservingTextView(completedSummary)
                        .font(Font.system(.headline))
                        .opacity(0.33)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                )
            }
        }
    }
}