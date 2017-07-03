//
//  LockUnionList.swift
//  blueToothTest
//
//  Created by pzs on 2017/7/3.
//  Copyright © 2017年 彭子上. All rights reserved.
//

import UIKit

class LockUnionList: UITableViewController {
    var deviceInfo = Dictionary<String, Any>.init()
    
    var devices = Array<Dictionary<String, String>>.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        devices =  UserDefaults.standard.array(forKey: self.deviceID(with: self.deviceInfo)) as! Array<Dictionary<String, String>>
        self.tableView.reloadData()
    }
    
    func deviceFullID(with infoDic:Dictionary<String, Any>) -> String! {
        let advdic=infoDic[AdvertisementData] as! NSDictionary
        return advdic.object(forKey: "kCBAdvDataLocalName") as! String?
    }
    
    func deviceID(with infoDic:Dictionary<String, Any>) -> String! {
        let advdic=infoDic[AdvertisementData] as! NSDictionary
        let deviceID =  advdic.object(forKey: "kCBAdvDataLocalName") as! String
        let indexOfDeviceID = deviceID.index(deviceID.startIndex, offsetBy: 7)
        let deviceMACID = deviceID.substring(from: indexOfDeviceID)
        return deviceMACID
    }
    // MARK: - Table view data source

    @IBAction func addUnion(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "lockaddunion", sender: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return devices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        let deviceID = cell.viewWithTag(1001) as! UILabel
        let deviceStatus = cell.viewWithTag(1001) as! UILabel
        deviceID.text = devices[indexPath.row]["deviceID"]
        deviceStatus.text = devices[indexPath.row]["deviceStatus"]
        
        // Configure the cell...

        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            devices.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target :LockAddUnionController = segue.destination as! LockAddUnionController
        target.devices = self.devices
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
