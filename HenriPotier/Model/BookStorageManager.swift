//
//  BookStorageManager.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 05/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BookStorageManager {

    let persistentContainer: NSPersistentContainer!

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    // MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    // MARK: CRUD
    func insertBook(book: BookData) -> Book? {
        guard let storageBook = NSEntityDescription.insertNewObject(
            forEntityName: "Book", into: backgroundContext) as? Book else { return nil }
        storageBook.isbn = book.isbn
        storageBook.title = book.title
        storageBook.price = Int16(book.price)
        storageBook.cover = book.cover
        storageBook.synopsis = book.getSynopsis()
        if let quantity = book.quantity {
            storageBook.quantity = Int16(quantity)
        } else {
            //if book is in storage, there is at least one of them
            storageBook.quantity = 1
        }
        return storageBook
    }

    func fetchAll() -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Book]()
    }

    func fetchBookData() -> [BookData] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        var books = [BookData]()

        guard let storage = results else {
            return books
        }

        for book in storage {
            if let isbn = book.isbn,
                let title = book.title,
                let cover = book.cover,
                let synopsis = book.synopsis {
                books.append(BookData(isbn: isbn, title: title, price: Int(book.price),
                                      cover: cover, synopsis: [synopsis], quantity: Int(book.quantity)))
            }
        }

        return books
    }

    func remove(objectID: NSManagedObjectID) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }

    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
}
