//
//  BookService.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 03/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

struct BookData: Codable {
    let isbn: String
    let title: String
    let price: Int
    let cover: String
    let synopsis: [String]
}

class BookService {
    private var bookSession: URLSession
    private var task: URLSessionDataTask?

    //Init used for tests
    init(bookSession: URLSession = URLSession(configuration: .default)) {
        self.bookSession = bookSession
    }

    //Request to Henri Potier API, to retrieve books data
    func getBooks(callback: @escaping (Bool, [BookData]?) -> Void) {

        let components = URLComponents(string: "http://henri-potier.xebia.fr/books")

        //create url var from component
        guard let url = components?.url else {
            callback(false, nil)
            return
        }

        //set request as GET
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        task?.cancel()
        task = bookSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                //check if there are errors, and if data is not nil
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                //check if response status code isn't 200 (error)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                //try to decode JSON to an object
                guard let responseJSON = try? JSONDecoder().decode([BookData].self, from: data) else {
                    callback(false, nil)
                    print("error4")
                    return
                }

                //callback to send the decoded objects
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}
