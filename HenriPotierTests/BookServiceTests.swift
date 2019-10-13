//
//  BookServiceTests.swift
//  HenriPotierTests
//
//  Created by Kévin Courtois on 11/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import Mockingjay
import XCTest
@testable import HenriPotier

class BookServiceTests: XCTestCase {
    func testGivenBookDataWhenCallingGetSynopsisThenShouldReturnFormattedString() {
        let bookData = BookData(isbn: "", title: "", price: 0, cover: "", synopsis: ["Test","is","working"])
        XCTAssertEqual(bookData.getSynopsis(), "Test\n\nis\n\nworking\n\n")
    }

    func testGivenGoodDataWhenCallingGetBooksThenShouldHaveResultAndNoError() {
        let url = Bundle(for: type(of: self)).url(forResource: "Books", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        BookService().getBooks { (success, books) in
            XCTAssertTrue(success)
            XCTAssertNotNil(books)
            XCTAssertEqual(books?.count, 7)
            expec.fulfill()
        }

        wait(for: [expec], timeout: 1)
    }

    func testGivenNoDataWhenCallingGetBooksThenShouldNotSucceed() {
        let data = Data()
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        BookService().getBooks { (success, books) in
            XCTAssertFalse(success)
            XCTAssertNil(books)
            expec.fulfill()
        }

        wait(for: [expec], timeout: 1)
    }

    func testGivenBadDataWhenCallingGetBooksThenShouldNotSucceed() {
        let url = Bundle(for: type(of: self)).url(forResource: "Offers", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        BookService().getBooks { (success, books) in
            XCTAssertFalse(success)
            XCTAssertNil(books)
            expec.fulfill()
        }

        wait(for: [expec], timeout: 1)
    }
}
