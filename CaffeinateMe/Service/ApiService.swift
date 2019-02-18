//
//  ApiService.swift
//  CaffeinateMe
//
//  Created by Vishal Bharam on 2/16/19.
//  Copyright © 2019 Vishal Bharam. All rights reserved.
//

import Foundation

enum Constants: String {
    case clientId = "KZACEWB23OQF30VLJ4AX5NT5GHLHX1VUHONWI3PBQXJRUV1F"
    case clientSecret = "VBZCPO42C1I55OONS3EY3BU3IDLZ2OKQKHNA0DEDOPTKSH4R"
    case coffeeShopCategory = "4bf58dd8d48988d1e0931735"
}

public class ApiService {

    // GetData function to get JSON data
    func getData(url: URL, completionHandler: @escaping (([String: AnyObject]?) -> Void)) {

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error  in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] else { return }
                    guard let response = json["response"] as? [String: AnyObject] else { return }
                    completionHandler(response)
                    return

                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                } catch {
                    print("Something went wrong!")
                }
            }
            completionHandler(nil)
        }) // End of dataTaskWithURL
        task.resume()
    }// End of getData function
}
