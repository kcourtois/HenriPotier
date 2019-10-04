//
//  DiscountCalculator.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 04/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

class DiscountCalculator {

    //Returns total cost of given books when lowering the price by given percentage
    func percentage(percentage: Float, books: [BookData]) -> Float {
        return initialPrice(books: books) * (1 - percentage/100)
    }

    //Returns total cost of given books when lowering the price by given amount
    func minus(amount: Float, books: [BookData]) -> Float {
        return initialPrice(books: books) - amount
    }

    //Returns total cost of given books when lowering the price by given percentage
    func slice(sliceValue: Float, value: Float, books: [BookData]) -> Float {
        var price = initialPrice(books: books)
        var discount: Float = 0.0
        while price >= sliceValue {
            price -= sliceValue
            discount += value
        }
        return initialPrice(books: books) - discount
    }

    //Returns total price for all books of an array
    private func initialPrice(books: [BookData]) -> Float {
        var price = 0
        for book in books {
            price += book.price
        }
        return Float(price)
    }
}
