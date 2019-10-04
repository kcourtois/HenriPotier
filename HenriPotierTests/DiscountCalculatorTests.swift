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
    var books: [BookData] = []

    override func setUp() {
        calculator = DiscountCalculator()
        books = [BookData(isbn: "", title: "", price: 35, cover: "", synopsis: []),
                 BookData(isbn: "", title: "", price: 30, cover: "", synopsis: [])]
    }

    func testGivenInitialPriceWhenApplyingMinusDiscountThenAssertShouldBeTrue() {
        let finalPrice = calculator.minus(amount: 5, books: books)
        XCTAssertEqual(finalPrice, 60)
    }

    func testGivenInitialPriceWhenApplyingPercentageDiscountThenAssertShouldBeTrue() {
        let finalPrice = calculator.percentage(percentage: 5, books: books)
        XCTAssertEqual(finalPrice, 61.75)
    }

    func testGivenInitialPriceWhenApplyingSliceDiscountThenAssertShouldBeTrue() {
        let finalPrice = calculator.slice(sliceValue: 30, value: 5, books: books)
        XCTAssertEqual(finalPrice, 55)
    }
}
