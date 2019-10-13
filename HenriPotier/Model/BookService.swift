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

    //returns full synopsis as one formated string
    func getSynopsis() -> String {
        var formatedSynopsis = ""
        for text in synopsis {
            formatedSynopsis += "\(text)\n\n"
        }
        return formatedSynopsis
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
                //Check if request was successful and data not empty
                guard response.result.isSuccess, let data = response.data else {
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
