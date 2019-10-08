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
    func getDiscount(books: [BookData], callback: @escaping (Bool, [DiscountData]?) -> Void) {
        //Create url for Henri Potier API
        var url: String = "http://henri-potier.xebia.fr/books/"

        for index in 0..<books.count-1 {
            url += "\(books[index].isbn),"
        }

        url += "\(books[books.count-1].isbn)/commercialOffers"

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
                guard let responseJSON = try? JSONDecoder().decode(DiscountRequest.self, from: data) else {
                    callback(false, nil)
                    return
                }

                //If everything is OK, callback with success and data
                callback(true, responseJSON.offers)
        }
    }
}
