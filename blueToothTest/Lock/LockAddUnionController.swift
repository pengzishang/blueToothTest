//
//  LockAddUnionController.swift
//  blueToothTest
//
//  Created by pzs on 2017/7/3.
//  Copyright © 2017年 彭子上. All rights reserved.
//

import UIKit

class LockAddUnionController: UITableViewController {
    var devices = Array<Dictionary<String, String>>.init()
    var deviceInfo = Dictionary<String, Any>.init()
    var notExist = Array<Dictionary<String, Any>>.init()
    let allDevice = BluetoothManager.getInstance()?.peripheralsInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allDevice?.forEach({ (deviceInfo) in
            let deviceTypeString = self.deviceType(with: deviceInfo as! Dictionary<String, Any>)
            let deviceTypeInt = Int(deviceTypeString!)
            guard deviceTypeInt! <= 5 else
            {
                return
            }
            
            let deviceFullName = self.deviceFullID(with: deviceInfo as! Dictionary<String, Any>)
            if devices.contains(where: { (dic) -> Bool in
                return dic["deviceID"] == deviceFullName ? true:false
            })
            {
                notExist.append(deviceInfo as! [String : Any])
            }
        })
        
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func deviceID(with infoDic:Dictionary<String, Any>) -> String! {
        let advdic=infoDic[AdvertisementData] as! NSDictionary
        let deviceID =  advdic.object(forKey: "kCBAdvDataLocalName") as! String
        let indexOfDeviceID = deviceID.index(deviceID.startIndex, offsetBy: 7)
        let deviceMACID = deviceID.substring(from: indexOfDeviceID)
        return deviceMACID
    }
    
    func deviceType(with infoDic:Dictionary<String, Any>) -> String! {
        let advdic=infoDic[AdvertisementData] as! NSDictionary
        let deviceID =  advdic.object(forKey: "kCBAdvDataLocalName") as! String
        let startOfDeviceID = deviceID.index(deviceID.startIndex, offsetBy: 4)
        let devicesub1 = deviceID.substring(from: startOfDeviceID)
        let endOfDeviceID = devicesub1.index(devicesub1.startIndex, offsetBy: 2)
        let deviceType = devicesub1.substring(to: endOfDeviceID)
        return deviceType
    }
    
    
    func deviceFullID(with infoDic:Dictionary<String, Any>) -> String! {
        let advdic=infoDic[AdvertisementData] as! NSDictionary
        return advdic.object(forKey: "kCBAdvDataLocalName") as! String?
    }
    
    
    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notExist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        let deviceID = cell.viewWithTag(1001) as! UILabel
        deviceID.text = self.deviceFullID(with: notExist[indexPath.row])
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController.init(title: "状态", message: "输入要设定的状态", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            
            var deviceArray =  UserDefaults.standard.array(forKey: self.deviceFullID(with: self.notExist[indexPath.row])) as! Array<Dictionary<String, String>>
            deviceArray.append(["deviceID":self.deviceFullID(with: self.notExist[indexPath.row]),"deviceStatus":(alert.textFields?.first?.text)!])
            UserDefaults.standard.set(deviceArray, forKey: self.deviceID(with: self.deviceInfo))
            self.navigationController?.popViewController(animated: true)
            
            
        }))
        self.present(alert, animated: true) {
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
