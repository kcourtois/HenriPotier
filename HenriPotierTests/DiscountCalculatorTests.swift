//
//  DiscountCalculatorTests.swift
//  HenriPotierTests
//
//  Created by Kévin Courtois on 05/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import XCTest
import Mockingjay
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

    func testGivenBooksInCartWhenCallingApplyDiscountThenDiscountShouldBeMinus() {
        let url = Bundle(for: type(of: self)).url(forResource: "Offers", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book(isbn: "test1", title: "test1", price: 30, cover: "test1", synopsis: "test1", quantity: 1),
                     Book(isbn: "test2", title: "test2", price: 20, cover: "test2", synopsis: "test2", quantity: 1)]

        calculator.applyDiscount(books: books) { (finalPrice) in
            XCTAssertEqual(finalPrice, 42)
            expec.fulfill()
        }

        wait(for: [expec], timeout: 1)
    }

    func testGivenBooksInCartWhenCallingApplyDiscountThenDiscountShouldBePercentage() {
        let url = Bundle(for: type(of: self)).url(forResource: "Offers", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book(isbn: "test1", title: "test1", price: 30, cover: "test1", synopsis: "test1", quantity: 2),
                     Book(isbn: "test2", title: "test2", price: 20, cover: "test2", synopsis: "test2", quantity: 2)]

        calculator.applyDiscount(books: books) { (finalPrice) in
            XCTAssertEqual(finalPrice, 90)
            expec.fulfill()
        }

        wait(for: [expec], timeout: 1)
    }

    func testGivenBooksInCartWhenCallingApplyDiscountThenDiscountShouldBeSlice() {
        let url = Bundle(for: type(of: self)).url(forResource: "Offers", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book(isbn: "test1", title: "test1", price: 30, cover: "test1", synopsis: "test1", quantity: 3),
                     Book(isbn: "test2", title: "test2", price: 20, cover: "test2", synopsis: "test2", quantity: 3)]

        calculator.applyDiscount(books: books) { (finalPrice) in
            XCTAssertEqual(finalPrice, 130)
            expec.fulfill()
        }

        wait(for: [expec], timeout: 1)
    }

    func testGivenDiscountServiceErrorWhenCallingApplyDiscountThenPriceShouldBeInitialPrice() {
        let data = Data()
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book(isbn: "test1", title: "test1", price: 30, cover: "test1", synopsis: "test1", quantity: 3),
                     Book(isbn: "test2", title: "test2", price: 20, cover: "test2", synopsis: "test2", quantity: 3)]

        calculator.applyDiscount(books: books) { (finalPrice) in
            XCTAssertEqual(finalPrice, 150)
            expec.fulfill()
        }

        wait(for: [expec], timeout: 1)
    }
}
