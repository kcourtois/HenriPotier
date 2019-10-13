//
//  DiscountService.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 05/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import Alamofire

struct DiscountRequest: Codable {
    let offers: [DiscountData]
}

struct DiscountData: Codable {
    let type: DiscountType
    let sliceValue: Float?
    let value: Float
}

enum DiscountType: String, Codable {
    case percentage, minus, slice
}

class DiscountService {
    //Request to Henri Potier API, to retrieve discount data
    func getDiscount(books: [Book], callback: @escaping (Bool, [DiscountData]?) -> Void) {
        //if there are no books, can't fetch a discount
        guard !books.isEmpty else {
            callback(false, nil)
            return
        }

        //Base URL
        var url: String = "http://henri-potier.xebia.fr/books/"

        //For each book
        for bookIndex in 0..<books.count {
            //And each copy
            for _ in 0..<books[bookIndex].quantity {
                //add isbn to the url
                url += "\(books[bookIndex].isbn),"
            }
        }

        //remove last comma
        url.remove(at: url.index(before: url.endIndex))
        //Add end of path
        url += "/commercialOffers"

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
                guard let responseJSON = try? JSONDecoder().decode(DiscountRequest.self, from: data) else {
                    callback(false, nil)
                    return
                }

                //If everything is OK, callback with success and data
                callback(true, responseJSON.offers)
        }
    }
}
