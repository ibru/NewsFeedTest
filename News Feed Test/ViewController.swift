//
//  ViewController.swift
//  News Feed Test
//
//  Created by Jiri Urbasek on 21/04/15.
//  Copyright (c) 2015 Jiri Urbasek. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    struct TableConstants {
        static let cellIdentifier = "Table Cell"
    }
    
    var controllerNames = ["Table View", "Collection View 1", "Collection View 2", "Collection View 3", "Collection View 4"]
    var controllerClasses = ["TableViewController", "CollectionView1Controller", "CollectionView2Controller", "CollectionView3Controller", "CollectionView4Controller"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableConstants.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = controllerNames[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier(controllerClasses[indexPath.row]) as! UIViewController
        navigationController?.pushViewController(controller, animated: true)
    }
}

