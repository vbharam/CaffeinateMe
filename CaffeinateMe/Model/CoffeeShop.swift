//
//  CoffeeShop.swift
//  CaffeinateMe
//
//  Created by Vishal Bharam on 2/16/19.
//  Copyright © 2019 Vishal Bharam. All rights reserved.
//

import Foundation

class CoffeeShop: Codable {
    class Venue: Codable {
        let id: String?
        let name: String?

        class Location: Codable {
            let address: String?
            let city: String?
            let state: String?
            let postalCode: String?
            let distance: Int?
        }

        let location: Location
    }
    let venue: Venue
}

class CoffeeShopDetails: Codable {
    class Hours: Codable {
        let status: String?
        let isOpen: Bool
    }    
    let rating: Double
    let description: String?
    let hours: Hours
}
