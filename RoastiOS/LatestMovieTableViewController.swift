//
//  LatestMovieTableViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/14/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit

class LatestMovieTableViewController: UITableViewController {
    var items: NSMutableArray = []
    
    @IBOutlet weak var refresher: UIRefreshControl!
    
    func reload() {
        let api = RemoteAPI(type: "movie", query: nil)
        api.getData({data, error -> Void in
            if (data != nil) {
                self.items = NSMutableArray(array: data)
                self.tableView!.reloadData()
            } else {
                print("api.getData failed")
                print(error)
            }
            self.refresher.endRefreshing()
        })
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresher.beginRefreshing()
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        reload()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        if let movieTitle = self.items[indexPath.row]["title"] as! String? {
            cell.textLabel!.text = movieTitle
        } else {
            cell.textLabel!.text = "No Name"
        }
        return cell
    }
}