//
//  SearchTableViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/24/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    var items: NSMutableArray = []
    
    @IBOutlet weak var refresher: UIRefreshControl!
    @IBOutlet weak var sbContent: UISearchBar!
    
    @IBAction func refresh(sender: AnyObject) {
        reload()
    }
    
    func reload() {
        let api = RemoteAPI(type: "dvd", query: nil)
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
    
    func research(query: String!) {
        self.refresher.beginRefreshing()
        let api = RemoteAPI(type: "search", query: query)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresher.beginRefreshing()
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.sbContent!.delegate = self
        reload()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.research(searchBar.text!)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultMovieCell", forIndexPath: indexPath)
        //UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        // print(self.items[indexPath.row])
        if let movieTitle = self.items[indexPath.row]["title"] as! String? {
            cell.textLabel!.text = movieTitle
        } else {
            cell.textLabel!.text = "No Name"
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowDetail") {
            let targetView = segue.destinationViewController as! MovieDetailViewController
            if let selectedCell = sender as? UITableViewCell {
                let index = self.tableView.indexPathForCell(selectedCell)
                let values = self.items[(index?.row)!]
                targetView.movie = Movie(title: values["title"] as! String?, id: values["id"] as! String?)
            }
        }
    }
}

