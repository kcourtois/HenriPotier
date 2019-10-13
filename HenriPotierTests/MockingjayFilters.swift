//
//  MockingjayFiltersExtension.swift
//  HenriPotierTests
//
//  Created by Kévin Courtois on 12/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Mockingjay

//Extension for filters (mockingjay)
class MockingjayFilters {
//    static func matcherNoFilters(request: URLRequest) -> Bool {
//        let urlToSearch =
//            "http://api.edamam.com/search?q=mozzarella goat cheese" +
//                "&app_id=\(ApiKeys.edamamAppId)&" +
//        "app_key=\(ApiKeys.edamamKey)"
//
//        guard let urlString = urlToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//            let urlDef = URL(string: urlString) else {
//                return false
//        }
//
//        let requestToCompare = URLRequest(url: urlDef)
//        print("MEYDEN: \(requestToCompare) \(request)")
//
//        return request.url == requestToCompare.url
//    }
//
//    static func matcherFilters(request: URLRequest) -> Bool {
//        let urlToSearch =
//            "http://api.edamam.com/search?q=mozzarella goat cheese" +
//                "&app_id=\(ApiKeys.edamamAppId)&" +
//                "app_key=\(ApiKeys.edamamKey)" +
//        "&health=alcohol-free&health=vegetarian"
//
//        guard let urlString = urlToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//            let urlDef = URL(string: urlString) else {
//                return false
//        }
//
//        let requestToCompare = URLRequest(url: urlDef)
//
//        return request.url == requestToCompare.url
//    }

    static func matcherImages(request: URLRequest) -> Bool {

        //let baseUrl = "http://www.edamam.com/ontologies/edamam.owl#recipe"

        let baseUrl = "https://www.edamam.com/web-img/"

        guard let url = request.url else {
            return false
        }

        let requestBase = url.absoluteString.prefix(baseUrl.count)

        return baseUrl == requestBase
    }
}
