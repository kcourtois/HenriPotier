//
//  BookServiceTests.swift
//  HenriPotierTests
//
//  Created by Kévin Courtois on 11/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Mockingjay
import XCTest
@testable import HenriPotier

class BookServiceTests: XCTestCase {
    func testGivenBookDataWhenCallingGetSynopsisThenShouldReturnFormattedString() {
        let bookData = BookData(isbn: "", title: "", price: 0, cover: "", synopsis: ["Test", "is", "working"])
        XCTAssertEqual(bookData.getSynopsis(), "Test\n\nis\n\nworking\n\n")
    }

    func testGivenGoodDataWhenCallingGetBooksThenShouldHaveResultAndNoError() {
        let url = Bundle(for: type(of: self)).url(forResource: "Books", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        BookService().getBooks(completion: { result in
            switch result {
            case .failure:
                XCTAssertTrue(false)
            case .success(let books):
                XCTAssertEqual(books.count, 7)
            }
            expec.fulfill()
        })

        wait(for: [expec], timeout: 1)
    }

    func testGivenNoDataWhenCallingGetBooksThenShouldNotSucceed() {
        let data = Data()
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        BookService().getBooks(completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .noDataAvailable)
            case .success:
                XCTAssertTrue(false)
            }
            expec.fulfill()
        })

        wait(for: [expec], timeout: 1)
    }

    func testGivenBadDataWhenCallingGetBooksThenShouldNotSucceed() {
        let url = Bundle(for: type(of: self)).url(forResource: "Offers", withExtension: "json")!
        // swiftlint:disable:next force_try
        let data = try! Data(contentsOf: url)
        stub(everything, jsonData(data))

        let expec = expectation(description: "Alamofire")

        BookService().getBooks(completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .cantDecodeData)
            case .success:
                XCTAssertTrue(false)
            }
            expec.fulfill()
        })

        wait(for: [expec], timeout: 1)
    }
}
