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

enum BookError: Error {
    case noDataAvailable
    case cantDecodeData
}

class BookService {
    //Request to Henri Potier API, to retrieve books data
    func getBooks(completion: @escaping (Swift.Result<[Book], BookError>) -> Void) {
        //Create request to fetch JSON
        Alamofire.request(ServiceStrings.baseUrl, method: .get, parameters: nil)
            .validate()
            .responseJSON { response in
                //Check if request was successful and data not empty
                guard response.result.isSuccess, let data = response.data else {
                    completion(.failure(.noDataAvailable))
                    return
                }

                //Try to parse data into JSON
                guard let responseJSON = try? JSONDecoder().decode([BookData].self, from: data) else {
                    completion(.failure(.cantDecodeData))
                    return
                }

                //Convert BookData array to Book array
                let books = responseJSON.map {
                    Book(isbn: $0.isbn, title: $0.title, price: $0.price, cover: $0.cover,
                         synopsis: $0.getSynopsis(), quantity: 1)
                }

                //If everything is OK, callback with success and data
                completion(.success(books))
        }
    }
}
