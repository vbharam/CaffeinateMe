//
//  CoffeeShopTableViewCell.swift
//  CaffeinateMe
//
//  Created by Vishal Bharam on 2/16/19.
//  Copyright © 2019 Vishal Bharam. All rights reserved.
//

import UIKit

class CoffeeShopTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var desc: UILabel!

    func updateUI(with data: CoffeeShop, detailsData: CoffeeShopDetails?, isActive: Bool) {
        name.text = data.venue.name
        let location = data.venue.location
        distance.text = convertMetersToMiles(distance: location.distance)
        address.text = "\(location.address ?? "") \(location.city ?? "") \(location.state ?? "") \(location.postalCode ?? "")"
        desc.isHidden = !isActive
        time.isHidden = !isActive
        ratings.isHidden = !isActive

        if let detailsData = detailsData, isActive {
            desc.text = detailsData.description
            time.text = "Time: \(detailsData.hours.status ?? "")"
            ratings.text = "Ratings: \(detailsData.rating)/10"
        }
    }

    func convertMetersToMiles(distance: Int?) -> String? {
        guard let distance = distance else { return "" }
        let miles = 0.00062137 * Double(distance)
        let distanceString = String(format: "%.1fmi", miles)
        return distanceString
    }
}

