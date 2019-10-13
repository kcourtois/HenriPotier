//
//  DiscountServiceTests.swift
//  HenriPotierTests
//
//  Created by Kévin Courtois on 11/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Mockingjay
import XCTest
@testable import HenriPotier

class DiscountServiceTests: XCTestCase {
    func testGivenGoodDataWhenCallingGetBooksThenShouldHaveResultAndNoError() {
        let url = Bundle(for: type(of: self)).url(forResource: "Offers", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book(isbn: "test1", title: "test1", price: 0, cover: "test1", synopsis: "test1", quantity: 1),
                     Book(isbn: "test2", title: "test2", price: 0, cover: "test2", synopsis: "test2", quantity: 1)]

        DiscountService().getDiscount(books: books, callback: { (success, offers) in
            XCTAssertTrue(success)
            XCTAssertNotNil(offers)
            XCTAssertEqual(offers?.count, 3)
            expec.fulfill()
        })

        wait(for: [expec], timeout: 1)
    }

    func testGivenNoBooksInArrayWhenCallingGetBooksThenShouldHaveResultAndNoError() {
        let url = Bundle(for: type(of: self)).url(forResource: "Offers", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book]()

        DiscountService().getDiscount(books: books, callback: { (success, offers) in
            XCTAssertFalse(success)
            XCTAssertNil(offers)
            expec.fulfill()
        })

        wait(for: [expec], timeout: 1)
    }

    func testGivenNoDataWhenCallingGetBooksThenShouldNotSucceed() {
        let data = Data()
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book(isbn: "test1", title: "test1", price: 0, cover: "test1", synopsis: "test1", quantity: 1),
                     Book(isbn: "test2", title: "test2", price: 0, cover: "test2", synopsis: "test2", quantity: 1)]

        DiscountService().getDiscount(books: books, callback: { (success, offers) in
            XCTAssertFalse(success)
            XCTAssertNil(offers)
            expec.fulfill()
        })

        wait(for: [expec], timeout: 1)
    }

    func testGivenBadDataWhenCallingGetBooksThenShouldNotSucceed() {
        let url = Bundle(for: type(of: self)).url(forResource: "Books", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        let books = [Book(isbn: "test1", title: "test1", price: 0, cover: "test1", synopsis: "test1", quantity: 1),
                     Book(isbn: "test2", title: "test2", price: 0, cover: "test2", synopsis: "test2", quantity: 1)]

        DiscountService().getDiscount(books: books, callback: { (success, offers) in
            XCTAssertFalse(success)
            XCTAssertNil(offers)
            expec.fulfill()
        })

        wait(for: [expec], timeout: 1)
    }
}
