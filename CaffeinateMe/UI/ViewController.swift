//
//  ViewController.swift
//  CaffeinateMe
//
//  Created by Vishal Bharam on 2/16/19.
//  Copyright © 2019 Vishal Bharam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var dataManager: DataFetchManagerProtocol!
    var coffeeShops: [CoffeeShop] = []
    var cachedData: [IndexPath: CoffeeShopDetails] = [:]
    var selectedIndexpath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataFetchManager()
        tableView.delegate = self
        tableView.dataSource = self
        // Get initial data:
        self.fetchData()
    }

    func fetchData() {
        dataManager.fetchAllCoffeeShops(completion: { (items) in
            if !items.isEmpty {
                self.coffeeShops = items
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeShops.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedIndexpath = selectedIndexpath, indexPath == selectedIndexpath {
            return 140.0
        }
        return 55.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeShopCell") as? CoffeeShopTableViewCell {
            let data = coffeeShops[indexPath.row]
            let isActive = selectedIndexpath != nil && selectedIndexpath == indexPath
            cell.updateUI(with: data, detailsData: cachedData[indexPath], isActive: isActive)
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = cachedData[indexPath] {
            tableView.reloadData()
            // tableView.reloadRows(at: [selectedIndexpath!, indexPath], with: .fade)
        } else {
            let data = coffeeShops[indexPath.row]
            dataManager.fetchCoffeeShopDetails(id: data.venue.id, completion: { (itemDetail) in
                guard itemDetail != nil else { return }
                self.cachedData[indexPath] = itemDetail
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    // self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            })
        }
        selectedIndexpath = selectedIndexpath != nil && selectedIndexpath! == indexPath ? nil : indexPath
    }
}

