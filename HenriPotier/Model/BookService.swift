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
        synopsis.reduce("") { $0 + "\($1)\n\n" }
    }
}

class BookService {
    //Request to Henri Potier API, to retrieve books data
    func getBooks(callback: @escaping (Bool, [Book]?) -> Void) {
        //Create request to fetch JSON
        Alamofire.request(ServiceStrings.baseUrl, method: .get, parameters: nil)
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
                let books = responseJSON.map {
                    Book(isbn: $0.isbn, title: $0.title, price: $0.price, cover: $0.cover,
                         synopsis: $0.getSynopsis(), quantity: 1)
                }

                //If everything is OK, callback with success and data
                callback(true, books)
        }
    }
}
