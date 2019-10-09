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
    //Get all books in cart
    func getBooksInCart() -> [Book] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Book.self))
        } catch {
            //TODO: Nil ?
            print("something went wrong")
            return []
        }
    }

    //add book to cart
    func addToCart(book: Book) {
        do {
            let realm = try Realm()
            let books = realm.objects(Book.self).filter("isbn == '\(book.isbn)'")

            if let bookInCart = books.first {
                try realm.write {
                    bookInCart.quantity += 1
                }
            } else {
                try realm.write {
                    realm.add(book)
                }
            }
        } catch {
            //TODO: Error
        }
    }

    //delete book from cart
    func deleteFromCart(book: Book) {
        do {
            let realm = try Realm()
            let books = realm.objects(Book.self).filter("isbn == '\(book.isbn)'")

            if let bookInCart = books.first {
                try realm.write {
                    bookInCart.quantity -= 1
                    if bookInCart.quantity <= 0 {
                        realm.delete(bookInCart)
                    }
                }
            }
        } catch {
            //TODO: Error
        }
    }

    //delete all copies of the same book
    func deleteAllCopies(book: Book) {
        do {
            let realm = try Realm()
            let books = realm.objects(Book.self).filter("isbn == '\(book.isbn)'")

            if let bookInCart = books.first {
                try realm.write {
                    realm.delete(bookInCart)
                }
            }
        } catch {
            //TODO: Error
        }
    }
}
