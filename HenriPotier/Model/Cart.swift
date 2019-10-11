//
//  File.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 09/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import RealmSwift

class Cart {

    let realm: Realm!

    init(realm: Realm) {
        self.realm = realm
    }

    //init with default Realm
    convenience init() {
        // swiftlint:disable:next force_try
        self.init(realm: try! Realm())
    }

    //Get all books in cart
    func getBooksInCart() -> [Book] {
        //return all the books stored as an array
        return Array(realm.objects(Book.self))
    }

    //add book to cart
    func addToCart(book: Book, completion: @escaping (Bool) -> Void) {
        do {
            //Add a filter on book isbn
            let books = realm.objects(Book.self).filter("isbn == '\(book.isbn)'")

            //Retrive first book in the filtered array
            if let bookInCart = books.first {
                try realm.write {
                    //add 1 in quantity
                    bookInCart.quantity += 1
                    completion(true)
                }
            } else {
                try realm.write {
                    //If book wasn't already in the cart, add it
                    realm.add(book)
                    completion(true)
                }
            }
        } catch {
            //If there was an error, complete with false
            completion(false)
        }
    }

    //delete book from cart
    func deleteFromCart(book: Book, completion: @escaping (Bool) -> Void) {
        do {
            //Add a filter on book isbn
            let books = realm.objects(Book.self).filter("isbn == '\(book.isbn)'")
            //Retrive first book in the filtered array
            if let bookInCart = books.first {
                try realm.write {
                    //remove one in quantity
                    bookInCart.quantity -= 1
                    //delete it from cart if there are no more copies
                    if bookInCart.quantity <= 0 {
                        realm.delete(bookInCart)
                    }
                    completion(true)
                }
            }
        } catch {
            //If there was an error, complete with false
            completion(false)
        }
    }

    //delete all copies of the same book
    func deleteAllCopies(book: Book, completion: @escaping (Bool) -> Void) {
        do {
            //Add a filter on book isbn
            let books = realm.objects(Book.self).filter("isbn == '\(book.isbn)'")
            //if we found the book, delete it
            if let bookInCart = books.first {
                try realm.write {
                    realm.delete(bookInCart)
                    completion(true)
                }
            }
        } catch {
            //If there was an error, complete with false
            completion(false)
        }
    }
}
