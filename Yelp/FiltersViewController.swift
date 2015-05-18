//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Venkata Vijay on 5/17/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController:FiltersViewController, didUpdateFilters filters:[String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var sortByPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    var sort = ["Best Matched", "Distance", "Highest Rated"]
    var categories:[[String: String]]!
    var deals = false
    var switchCategoryStates = [Int: Bool]()
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        categories = yelpCategories()
        sortByPicker.dataSource = self
        sortByPicker.delegate = self
        self.tableView.reloadData()
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String: AnyObject]()
        
        var selectCategories = [String]()
        for(row,isSelected) in switchCategoryStates {
            if isSelected {
                selectCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectCategories.count > 0 {
            filters["categories"] = selectCategories
        }

        filters["deals"] = self.deals
        filters["sort"] = sortByPicker.selectedRowInComponent(0)
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func yelpCategories() -> [[String: String]]{
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"]]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return categories.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        if(indexPath.section == 0) {
            let cuisineName = self.categories[indexPath.row]["name"]
        
            cell.switchLabel.text = cuisineName
        }
        
        if(indexPath.section == 1) {
            cell.switchLabel.text = "Deals Only: "
        }
        
        cell.delegate = self
        
        if (indexPath.section == 0) {
            cell.onSwitch.on = switchCategoryStates[indexPath.row] ?? false
        } else if (indexPath.section == 1) {
            cell.onSwitch.on = self.deals
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if(section == 0) {
            return "Cuisine"
        }
        
        if(section == 1) {
            return "Deals"
        }
        
        return "Others"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func numberOfComponentsInPickerView(sortByPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(sortByPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sort.count
    }
    
    func pickerView(sortByPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return sort[row]
    }

    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        println("Value changed from view controller")
        
        let indexPath = tableView.indexPathForCell(switchCell)!
        
        if(indexPath.section == 0) {
            switchCategoryStates[indexPath.row] = value
        } else if (indexPath.section == 1) {
            self.deals = value
        }
        
        println(switchCategoryStates)
        println(self.deals)
        
    }
}
