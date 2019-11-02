//
//  DiscountCalculator.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 04/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

class DiscountCalculator {

    let discountService: DiscountService

    init(discountService: DiscountService = DiscountService()) {
        self.discountService = discountService
    }

    //Apply all the available discounts, and gives the lowest price on completion
    func applyDiscount(books: [Book], completion: @escaping (Float) -> Void) {
        //check available discounts
        discountService.getDiscount(books: books) { result in
            switch result {
            case .failure:
                //in case of failure, completion with total price of the books
                completion(self.initialPrice(books: books))
                return
            case .success(let offers):
                //final price is minimum value in the array of prices
                if let finalPrice = self.getLoweredPrices(offers: offers, books: books).min() {
                    //completion called with best price
                    completion(finalPrice)
                } else {
                    //if finalPrice not set, complete with initialPrice
                    completion(self.initialPrice(books: books))
                }
            }
        }
    }

    //Returns total cost of given books when lowering the price by given percentage
    func percentage(percentage: Float, books: [Book]) -> Float {
        initialPrice(books: books) * (1 - percentage/100)
    }

    //Returns total cost of given books when lowering the price by given amount
    func minus(amount: Float, books: [Book]) -> Float {
        initialPrice(books: books) - amount
    }

    //Returns total cost of given books when lowering the price by given percentage
    func slice(sliceValue: Float?, value: Float, books: [Book]) -> Float {
        if let sliceValue = sliceValue {
            var price = initialPrice(books: books)
            var discount: Float = 0.0
            while price >= sliceValue {
                price -= sliceValue
                discount += value
            }
            return initialPrice(books: books) - discount
        } else {
            return initialPrice(books: books)
        }
    }

    //Returns total price for all books of an array
    func initialPrice(books: [Book]) -> Float {
        Float(books.reduce(0) { $0 + $1.price * $1.quantity })
    }

    //Used by applyDiscount, check which offer is the best of all and return the lowest price found
    private func getLoweredPrices(offers: [DiscountData], books: [Book]) -> [Float] {
        var values = [Float]()
        for discount in offers {
            switch discount.type {
            case .minus:
                values.append(self.minus(amount: discount.value, books: books))
            case .slice:
                values.append(self.slice(sliceValue: discount.sliceValue, value: discount.value, books: books))
            case .percentage:
                values.append(self.percentage(percentage: discount.value, books: books))
            }
        }
        return values
    }
}
