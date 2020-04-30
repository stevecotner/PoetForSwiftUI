//
//  RetailTutorial-Evaluator.swift
//  Poet
//
//  Created by Stephen E Cotner on 4/29/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

extension RetailTutorial {
    class Evaluator {
        
        // Translator
        
        lazy var translator: Translator = Translator(current)
        
        // Step
        
        var current = PassableStep(Step.loading)
        
        // BottomButtonAction
        
        enum BottomButtonAction: EvaluatorAction {
            case startOrder
            case advanceToDeliveryStep
            case advanceToCompletedStep
            case advanceToCanceledStep
            case done
        }
        
        // Data
        var order: Order = Order(
            id: "6398327",
            products: [
            Product(
                title: "MacBook Pro 13” 1TB",
                upc: "885909918161",
                image: "macbookpro13",
                location: "Bin 1A"),
            
            Product(
                title: "MacBook Pro 13” 2TB",
                upc: "885909918162",
                image: "macbookpro13",
                location: "Bin 1B"),
            
            Product(
                title: "iPad Pro 11” 128gb",
                upc: "888462533391",
                image: "ipadpro11",
                location: "Bin 2B"),
            
            Product(
                title: "iPad Pro 11” 256gb",
                upc: "888462533392",
                image: "ipadpro11",
                location: "Bin 2C"),
            
            Product(
                title: "Magic Keyboard for iPad Pro 11”",
                upc: "888462153501",
                image: "magickeyboard11",
                location: "Bin 3A"),
            
            Product(
                title: "Magic Keyboard for iPad Pro 13”",
                upc: "888462153502",
                image: "magickeyboard11",
                location: "Bin 3B"),
            ]
        )
    }
}

// MARK: Data Types

struct Order {
    var id: String
    var products: [Product]
}

struct Product {
    var title: String
    var upc: String
    var image: String
    var location: String
}

struct FindableProduct {
    var product: Product
    var status: FoundStatus
    
    enum FoundStatus {
        case unknown
        case found
        case notFound
    }
}

extension RetailTutorial.Evaluator {
    
    enum Step: EvaluatorStep {
        case loading
        case notStarted(NotStartedConfiguration)
        case findProducts(FindProductsConfiguration)
        case chooseDeliveryLocation(ChooseDeliveryLocationConfiguration)
        case completed(CompletedConfiguration)
        case canceled(CanceledConfiguration)
    }
    
    // Configurations
    
    struct NotStartedConfiguration {
        var customer: String
        var orderID: String
        var products: [Product]
        var startAction: BottomButtonAction
    }
    
    struct FindProductsConfiguration {
        var customer: String
        var orderID: String
        var findableProducts: [FindableProduct]
        var startTime: Date
        var nextAction: BottomButtonAction?
    }
    
    struct ChooseDeliveryLocationConfiguration {
        var customer: String
        var orderID: String
        var products: [Product]
        var numberOfProductsRequested: Int
        var deliveryLocationChoices: [String]
        var deliveryLocationPreference: String?
        var startTime: Date
        var nextAction: BottomButtonAction?
    }
    
    struct CompletedConfiguration {
        var customer: String
        var orderID: String
        var deliveryLocation: String
        var products: [Product]
        var timeCompleted: Date
        var elapsedTime: TimeInterval
        var doneAction: BottomButtonAction
    }
    
    struct CanceledConfiguration {
        var customer: String
        var orderID: String
        var timeCompleted: Date
        var elapsedTime: TimeInterval
        var doneAction: BottomButtonAction
    }
}

// View Cycle

extension RetailTutorial.Evaluator: ViewCycleEvaluator {
    func viewDidAppear() {
        if case .loading = current.step {
            current.step = .notStarted(
                NotStartedConfiguration(
                    customer: "Bob Odenkirk",
                    orderID: order.id,
                    products: order.products,
                    startAction: BottomButtonAction.startOrder)
            )
        }
    }
}

// Actions

protocol EvaluatorAction {}

protocol BottomButtonEvaluator: class {
    func bottomButtonTapped(action: EvaluatorAction?)
}

extension RetailTutorial.Evaluator: BottomButtonEvaluator {
    
    func bottomButtonTapped(action: EvaluatorAction?) {
        guard let action = action as? BottomButtonAction else { return }
        
        switch action {
        case .startOrder:
            startOrder()
            
        case .advanceToDeliveryStep:
            advanceToDeliveryStep()
            
        case .advanceToCompletedStep:
            advanceToCompletedStep()
            
        case .advanceToCanceledStep:
            advanceToCanceledStep()
            
        case .done:
            debugPrint("done")
        }
    }
    
    // MARK: Advancing Between Steps
    
    func startOrder() {
        if case let .notStarted(configuration) = current.step {
            
            // not implemented yet -- asynchronous network call
            // performer.claim(configuration.orderID) // handle success and failure
            
            let newConfiguration = FindProductsConfiguration(
                customer: configuration.customer,
                orderID: configuration.orderID,
                findableProducts: configuration.products.map {
                    return FindableProduct(
                        product: $0,
                        status: .unknown)
                },
                startTime: Date(),
                nextAction: nil
            )
            
            current.step = .findProducts(newConfiguration)
        }
    }
    
    func advanceToDeliveryStep() {
        guard case let .findProducts(configuration) = current.step else { return }
        
        let newConfiguration = ChooseDeliveryLocationConfiguration(
            customer: configuration.customer,
            orderID: configuration.orderID,
            products: configuration.findableProducts.compactMap {
                if $0.status == .found {
                    return $0.product
                } else {
                    return nil
                }
            },
            numberOfProductsRequested: configuration.findableProducts.count,
            deliveryLocationChoices: ["Register", "Front Door"],
            deliveryLocationPreference: nil,
            startTime: configuration.startTime,
            nextAction: nil)
        
        current.step = .chooseDeliveryLocation(newConfiguration)
    }
    
    func advanceToCompletedStep() {
        guard case let .chooseDeliveryLocation(configuration) = current.step else { return }
        
        let newConfiguration = CompletedConfiguration(
            customer: configuration.customer,
            orderID: configuration.orderID,
            deliveryLocation: configuration.deliveryLocationPreference ?? "Unknown Location",
            products: configuration.products,
            timeCompleted: Date(),
            elapsedTime: abs(configuration.startTime.timeIntervalSinceNow),
            doneAction: .done
            )
        
        current.step = .completed(newConfiguration)
    }
    
    func advanceToCanceledStep() {
        guard case let .findProducts(configuration) = current.step else { return }
        
        let newConfiguration = CanceledConfiguration(
            customer: configuration.customer,
            orderID: configuration.orderID,
            timeCompleted: Date(),
            elapsedTime: abs(configuration.startTime.timeIntervalSinceNow),
            doneAction: .done
            )
        
        current.step = .canceled(newConfiguration)
    }
}

// MARK: Finding Products Evaluator

extension RetailTutorial.Evaluator: FindingProductsEvaluator {
    func toggleProductFound(_ product: FindableProduct) {
        guard case let Step.findProducts(configuration) = current.step else { return }
        
        // Toggle status
        
        var modifiedProduct = product
        modifiedProduct.status = {
            switch modifiedProduct.status {
            case .found:
                return .unknown
            case .notFound, .unknown:
                return .found
            }
        }()
        
        updateFindableProduct(modifiedProduct, on: configuration)
        updateNextActionForFindableProducts()
    }
    
    func toggleProductNotFound(_ product: FindableProduct) {
        guard case let Step.findProducts(configuration) = current.step else { return }
        
        // Toggle status
        
        var modifiedProduct = product
        modifiedProduct.status = {
            switch modifiedProduct.status {
            case .notFound:
                return .unknown
            case .found, .unknown:
                return .notFound
            }
        }()
        
        updateFindableProduct(modifiedProduct, on: configuration)
        updateNextActionForFindableProducts()
    }
    
    func updateFindableProduct(_ modifiedProduct: FindableProduct, on configuration: FindProductsConfiguration) {
        var modifedConfiguration = configuration
        let findableProducts: [FindableProduct] = configuration.findableProducts.map {
            if $0.product.upc == modifiedProduct.product.upc {
                return modifiedProduct
            }
            return $0
        }
        
        modifedConfiguration.findableProducts = findableProducts
        
        current.step = .findProducts(modifedConfiguration)
    }
    
    func updateNextActionForFindableProducts() {
        guard case var Step.findProducts(configuration) = current.step else { return }
        
        let ready = configuration.findableProducts.allSatisfy { (findableProduct) -> Bool in
            findableProduct.status != .unknown
        }
        
        if ready {
            let noneFound = configuration.findableProducts.allSatisfy { (findableProduct) -> Bool in
                findableProduct.status == .notFound
            }
            if noneFound {
                configuration.nextAction = .advanceToCanceledStep
            } else {
                configuration.nextAction = .advanceToDeliveryStep
            }
        } else {
            configuration.nextAction = nil
        }
        
        current.step = .findProducts(configuration)
    }
}

// MARK: Options Evaluator

extension RetailTutorial.Evaluator: OptionsEvaluator {
    func toggleOption(_ option: String) {
        guard case var Step.chooseDeliveryLocation(configuration) = current.step else { return }
        
        if option == configuration.deliveryLocationPreference {
            configuration.deliveryLocationPreference = nil
            configuration.nextAction = nil
        } else {
            configuration.deliveryLocationPreference = option
            configuration.nextAction = .advanceToCompletedStep
        }
        
        current.step = .chooseDeliveryLocation(configuration)
    }
}