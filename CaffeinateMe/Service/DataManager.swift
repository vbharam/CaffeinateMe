//
//  DataManager.swift
//  CaffeinateMe
//
//  Created by Vishal Bharam on 2/16/19.
//  Copyright © 2019 Vishal Bharam. All rights reserved.
//

import Foundation


protocol DataFetchManagerProtocol {
    func fetchAllCoffeeShops(completion: @escaping ([CoffeeShop]) -> Void)
    func fetchCoffeeShopDetails(id: String?, completion: @escaping (CoffeeShopDetails?) -> Void)
}

public class DataFetchManager: DataFetchManagerProtocol {
    var service: ApiService!

    public init() {
        service = ApiService()
    }

    func fetchAllCoffeeShops(completion: @escaping ([CoffeeShop]) -> Void) {
        let placesUrl = URL(string: "https://api.foursquare.com/v2/venues/explore?ll=37.775299,-122.398064&section=coffee&limit=15&client_id=\(Constants.clientId.rawValue)&client_secret=\(Constants.clientSecret.rawValue)&v=20180323")!

        /*
        var urlRequest = URLRequest(url: placesUrl)
        urlRequest.httpMethod = "GET"

        var params: [String: Any] = [:]
        params["ll"] = "37.775299,-122.398064"
        params["section"] = "coffee"
        params["limit"] = "50"
        params["v"] = "20180323"
        params["client_id"] = Constants.clientId.rawValue
        params["client_secret"] = Constants.clientSecret.rawValue

        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = data
        } catch {}
        */

        service.getData(url: placesUrl) { (data) in
            guard let validData = data,
                let groupsData = validData["groups"] as? [[String: AnyObject]],
                let recommendedPlacesData = groupsData.first,
                let itemsData = recommendedPlacesData["items"] as? [[String: AnyObject]]
            else {
                completion([])
                return
            }

            if let itemsInfoBreakdownData = try? JSONSerialization.data(withJSONObject: itemsData as Any),
                let items = try? JSONDecoder().decode([CoffeeShop].self, from: itemsInfoBreakdownData) {
                completion(items)
                return
            }
            completion([])
        }
    }


    func fetchCoffeeShopDetails(id: String?, completion: @escaping (CoffeeShopDetails?) -> Void) {
        guard let id = id else { return }
        
        let detailsUrl = URL(string: "https://api.foursquare.com/v2/venues/\(id)?client_id=\(Constants.clientId.rawValue)&client_secret=\(Constants.clientSecret.rawValue)&v=20180323")!

        service.getData(url: detailsUrl) { (data) in
            guard let validData = data, let venueData = validData["venue"] as? [String: AnyObject] else {
                    completion(nil)
                    return
            }

            if let detailData = try? JSONSerialization.data(withJSONObject: venueData as Any),
                let detail = try? JSONDecoder().decode(CoffeeShopDetails.self, from: detailData) {
                completion(detail)
                return
            }
            completion(nil)
        }
    }
}

