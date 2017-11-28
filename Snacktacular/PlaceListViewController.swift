//
//  PlaceListViewController.swift
//  Snacktacular
//
//  Created by Mia Tortolani on 11/26/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var places = [PlaceData]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places.append(PlaceData(placeName: "Shake Shack", address: "The Street - Chestnut Hill", coordinate: CLLocationCoordinate2D(), postingUserID: ""))
        places.append(PlaceData(placeName: "Eagles Nest", address: "Mac", coordinate: CLLocationCoordinate2D(), postingUserID: ""))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.placeData = places[selectedRow]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            places[selectedIndexPath.row] = (source.placeData)!
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: places.count, section: 0)
            places.append((source.placeData)!)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }

}

extension PlaceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].placeName
        cell.detailTextLabel?.text = places[indexPath.row].address
        return cell
    }
}
