//
//  File.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 09/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic private(set) var isbn: String = ""
    @objc dynamic private(set) var title: String = ""
    @objc dynamic private(set) var price: Int = 0
    @objc dynamic private(set) var cover: String = ""
    @objc dynamic private(set) var synopsis: String = ""
    @objc dynamic var quantity: Int = 1

    convenience init(isbn: String, title: String, price: Int, cover: String, synopsis: String, quantity: Int) {
        self.init()
        self.isbn = isbn
        self.title = title
        self.price = price
        self.cover = cover
        self.synopsis = synopsis
        self.quantity = quantity
    }
}
