//
//  MasterViewController.swift
//  COUNTRIES
//
//  Created by Aaron Monick on 8/18/15.
//  Copyright (c) 2015 MONIX. All rights reserved.
//

import UIKit
import MapKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var countries = [Country]()
    var api = APIController()
    let url = NSURL(string: "http://api.worldbank.org/country?per_page=300&region=WLD&format=json")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        api.getJSONFromURL(url!, completion: { (results) -> Void in
            if let jsonResults = results {
                if let countries = jsonResults[1] as? NSArray {
                    self.countries.removeAll(keepCapacity: false)
                    for country in countries {
                        let name = country["name"] as! String
                        let id = country["id"] as! String
                        let capitalCity = country["capitalCity"] as! String
                        let long = country["longitude"] as! String
                        let lat = country["latitude"] as! String
                        let newCountry = Country(id: id, name: name, capital: capitalCity, long: long, lat: lat)
                        self.countries.append(newCountry)
                    }
                    self.tableView.reloadData()
                    if let detail = self.detailViewController {
                        detail.countries = self.countries
                        if detail.isViewLoaded() {
                            detail.loadMap()
                        }
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let country = countries[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.country = country
                controller.title = country.name
                controller.countries = self.countries
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = countries[indexPath.row].name
        cell.detailTextLabel?.text = countries[indexPath.row].capital
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

}

