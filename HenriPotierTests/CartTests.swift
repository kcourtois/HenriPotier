//
//  CartTests.swift
//  HenriPotierTests
//
//  Created by Kévin Courtois on 11/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import XCTest
import RealmSwift
@testable import HenriPotier

class CartTests: XCTestCase {

    var testRealm: Realm!
    var sut: Cart!

    override func setUp() {
        // swiftlint:disable:next force_try
        testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "tests-cart"))
        sut = Cart(realm: testRealm)
    }

    override func tearDown() {
        //remove data from testRealm
        // swiftlint:disable:next force_try
        try! testRealm.write {
            testRealm.deleteAll()
        }
    }

    func testGivenTwoBooksInCartWhenCallingGetBooksInCartThenShouldReturnTwoBooks() {
        //create two books
        let book1 = Book(isbn: "test1", title: "title1", price: 20, cover: "cover1", synopsis: "synopsis1", quantity: 1)
        let book2 = Book(isbn: "test2", title: "title2", price: 15, cover: "cover2", synopsis: "synopsis2", quantity: 1)

        //Add them into realm
        // swiftlint:disable:next force_try
        try! testRealm.write {
            testRealm.add(book1)
            testRealm.add(book2)
        }

        XCTAssertEqual(sut.getBooksInCart().count, 2)
    }

    func testGivenEmptyCartWhenAddingBookThenBookCountShouldBeOne() {
        //create a book
        let book = Book(isbn: "test1", title: "title1", price: 20, cover: "cover1", synopsis: "synopsis1", quantity: 1)
        //add it to cart
        sut.addToCart(book: book, completion: { success in
            XCTAssertTrue(success)
            XCTAssertEqual(self.testRealm.objects(Book.self).count, 1)
        })
    }

    func testGivenOneBookInCartWhenAddingSameBookThenBookQuantityShouldBeTwo() {
        //Create expectation
        let testExpectation = expectation(description: "Did finish operation expectation")

        //Create a book, and add it twice in cart
        let book = Book(isbn: "test1", title: "title1", price: 20, cover: "cover1", synopsis: "synopsis1", quantity: 1)
        sut.addToCart(book: book, completion: { _ in })
        sut.addToCart(book: book, completion: { _ in
            //when second book is added, expectation is fulfilled
            testExpectation.fulfill()
        })

        //Wait for expectation to be fulfilled
        waitForExpectations(timeout: 1, handler: nil)
        for book in testRealm.objects(Book.self) where book.isbn == "test1" {
            XCTAssertEqual(book.quantity, 2)
        }
    }

    func testGivenTwoCopiesOfABookInCartWhenRemovingSameBookThenBookQuantityShouldBeOne() {
        //Create expectation
        let testExpectation = expectation(description: "Did finish operation expectation")

        //Create a book
        let book = Book(isbn: "test1", title: "title1", price: 20, cover: "cover1", synopsis: "synopsis1", quantity: 2)

        //Add it into realm
        // swiftlint:disable:next force_try
        try! testRealm.write {
            testRealm.add(book)
        }

        //Call to delete method
        sut.deleteFromCart(book: book, completion: { _ in
            //when book deleted, expectation is fulfilled
            testExpectation.fulfill()
        })

        //Wait for expectation to be fulfilled
        waitForExpectations(timeout: 1, handler: nil)
        for book in testRealm.objects(Book.self) where book.isbn == "test1" {
            XCTAssertEqual(book.quantity, 1)
        }
    }

    func testGivenOneBookInCartWhenRemovingSameBookThenCartShouldBeEmpty() {
        //Create a book
        let book = Book(isbn: "test1", title: "title1", price: 20, cover: "cover1", synopsis: "synopsis1", quantity: 1)

        //Add it into realm
        // swiftlint:disable:next force_try
        try! testRealm.write {
            testRealm.add(book)
        }

        //Call to delete method
        sut.deleteFromCart(book: book, completion: { _ in
            XCTAssertEqual(self.testRealm.objects(Book.self).count, 0)
        })
    }

    func testGivenFiveCopiesOfABookInCartWhenRemovingAllCopiesThenCartShouldBeEmpty() {
        //Create a book
        let book = Book(isbn: "test1", title: "title1", price: 20, cover: "cover1", synopsis: "synopsis1", quantity: 5)

        //Add it into realm
        // swiftlint:disable:next force_try
        try! testRealm.write {
            testRealm.add(book)
        }

        //Call to delete method
        sut.deleteAllCopies(book: book, completion: { _ in
            XCTAssertEqual(self.testRealm.objects(Book.self).count, 0)
        })
    }
}
