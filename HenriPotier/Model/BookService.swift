//
//  BookService.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 03/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import Alamofire

struct BookData: Codable {
    let isbn: String
    let title: String
    let price: Int
    let cover: String
    let synopsis: [String]

    func getSynopsis() -> String {
        var str = ""
        for text in synopsis {
            str += "\(text)\n\n"
        }
        return str
    }
}

class BookService {
    //Request to Henri Potier API, to retrieve books data
    func getBooks(callback: @escaping (Bool, [Book]?) -> Void) {
        //Create url for Henri Potier API
        let url: String = "http://henri-potier.xebia.fr/books"

        //Create request to fetch JSON
        Alamofire.request(url, method: .get, parameters: nil)
            .validate()
            .responseJSON { response in
                //Check if request was successful
                guard response.result.isSuccess else {
                    callback(false, nil)
                    return
                }

                //Check if data is not empty
                guard let data = response.data else {
                    callback(false, nil)
                    return
                }

                //Try to parse data into JSON
                guard let responseJSON = try? JSONDecoder().decode([BookData].self, from: data) else {
                    callback(false, nil)
                    return
                }

                //Convert BookData array to Book array
                var books = [Book]()
                for book in responseJSON {
                    books.append(Book(isbn: book.isbn, title: book.title, price: book.price,
                                      cover: book.cover, synopsis: book.getSynopsis(), quantity: 1))
                }

                //If everything is OK, callback with success and data
                callback(true, books)
        }
    }
}
