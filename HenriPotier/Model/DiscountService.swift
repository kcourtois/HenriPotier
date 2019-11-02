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

enum DiscountError: Error {
    case noDataAvailable
    case cantDecodeData
    case emptyParameter
}


class DiscountService {
    //Request to Henri Potier API, to retrieve discount data
    func getDiscount(books: [Book],
                     completion: @escaping (Swift.Result<[DiscountData], DiscountError>) -> Void) {
        //if there are no books, can't fetch a discount
        guard !books.isEmpty else {
            completion(.failure(.emptyParameter))
            return
        }

        //Base URL
        var url: String = ServiceStrings.baseUrl

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
        url += ServiceStrings.offersEndOfPath

        //Create request to fetch JSON
        Alamofire.request(url, method: .get, parameters: nil)
            .validate()
            .responseJSON { response in
                //Check if request was successful and data not empty
                guard response.result.isSuccess, let data = response.data else {
                    completion(.failure(.noDataAvailable))
                    return
                }

                //Try to parse data into JSON
                guard let responseJSON = try? JSONDecoder().decode(DiscountRequest.self, from: data) else {
                    completion(.failure(.cantDecodeData))
                    return
                }

                //If everything is OK, callback with success and data
                completion(.success(responseJSON.offers))
        }
    }
}
