//
//  DiscountCalculatorTests.swift
//  HenriPotierTests
//
//  Created by Kévin Courtois on 05/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import XCTest
@testable import HenriPotier

class DiscountCalculatorTests: XCTestCase {

    var calculator: DiscountCalculator!
    var books: [Book] = []

    override func setUp() {
        calculator = DiscountCalculator()
        books = [Book(isbn: "", title: "", price: 35, cover: "", synopsis: "", quantity: 2),
                 Book(isbn: "", title: "", price: 30, cover: "", synopsis: "", quantity: 1)]
    }

    func testGivenInitialPriceWhenApplyingMinusDiscountThenAssertShouldBeTrue() {
        let finalPrice = calculator.minus(amount: 5, books: books)
        XCTAssertEqual(finalPrice, 95)
    }

    func testGivenInitialPriceWhenApplyingPercentageDiscountThenAssertShouldBeTrue() {
        let finalPrice = calculator.percentage(percentage: 5, books: books)
        XCTAssertEqual(finalPrice, 95)
    }

    func testGivenInitialPriceWhenApplyingSliceDiscountThenAssertShouldBeTrue() {
        let finalPrice = calculator.slice(sliceValue: 30, value: 5, books: books)
        XCTAssertEqual(finalPrice, 85)
    }

    func testGivenNilSliceWhenApplyingSliceDiscountThenAssertShouldBeTrue() {
        let finalPrice = calculator.slice(sliceValue: nil, value: 5, books: books)
        XCTAssertEqual(finalPrice, 100)
    }

    func testGivenBooksWhenCalculatingInitialPriceThenAssertShouldBeTrue() {
        let finalPrice = calculator.initialPrice(books: books)
        XCTAssertEqual(finalPrice, 100)
    }
}
