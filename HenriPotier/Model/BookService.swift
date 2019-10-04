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
}

class BookService {
    //Request to Henri Potier API, to retrieve books data
    func getBooks(callback: @escaping (Bool, [BookData]?) -> Void) {
        //Create url for Henri Potier API
        let URL: String = "http://henri-potier.xebia.fr/books"

        //Create request to fetch JSON
        Alamofire.request(URL, method: .get, parameters: nil)
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

                //If everything is OK, callback with success and data
                callback(true, responseJSON)
        }
    }
}
