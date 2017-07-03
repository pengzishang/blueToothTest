//
//  LockViewController.swift
//  blueToothTest
//
//  Created by pzs on 2017/6/29.
//  Copyright © 2017年 彭子上. All rights reserved.
//

import UIKit

class LockViewController: UITableViewController {
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var deviceInfo = Dictionary<String, Any>.init()
    
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var timePwdField: UITextField!
    @IBOutlet weak var addPwdField: UITextField!
    @IBOutlet weak var openPwdField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        BluetoothManager.getInstance()?.queryDeviceStatus(self.deviceID(with: deviceInfo), success: { (data) in
            let dataNS = NSData.init(data: data!)
            let subdata = dataNS.subdata(with: NSRange.init(location: 6, length: 4))
            let dataToNow = NSString.data(toInt: subdata);
            let data = NSDate.init(timeIntervalSince1970: 946684800)
            let dataNow = data.addingTimeInterval(TimeInterval(dataToNow))
            print(dataNow)
            self.timeLab.text = dataNow.description
        }, fail: { (failCode) -> UInt in
            print(">>>>>>" + failCode)
            return 0 
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func retry(_ sender: UIButton) {
        BluetoothManager.getInstance()?.queryDeviceStatus(self.deviceID(with: deviceInfo), success: { (data) in
            let dataNS = NSData.init(data: data!)
            let subdata = dataNS.subdata(with: NSRange.init(location: 6, length: 4))
            let dataToNow = NSString.data(toInt: subdata);
            let data = NSDate.init(timeIntervalSince1970: 946684800)
            let dataNow = data.addingTimeInterval(TimeInterval(dataToNow))
            print(dataNow)
            self.timeLab.text = dataNow.description
        }, fail: { (failCode) -> UInt in
            print(">>>>>>" + failCode)
            return 0
        })
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        guard indexPath.section==1 else {
            return
        }
        var APPOpertingEnterCommandPrefix: String = "00"
        var APPOpertingEnterCommandAll: String = ""
        
        
        if indexPath.row==0 {
            //开
            APPOpertingEnterCommandPrefix.append("1")
            
            APPOpertingEnterCommandAll = APPOpertingEnterCommandPrefix.appending(NSString.initWith(NSDate(timeIntervalSinceNow: 10000) as Date!, isRemote: false))
            APPOpertingEnterCommandAll = APPOpertingEnterCommandAll.appending(NSString.convertPassWord(openPwdField.text))
            BluetoothManager.getInstance()?.sendByteCommand(with: APPOpertingEnterCommandAll, deviceID: self.deviceID(with: deviceInfo), sendType: .lock, success: { (data) in
                
            }, fail: { (failCode) -> UInt in
                return 0
            })
        }
        else if indexPath.row==1 {
            //加密码
            let validTime = TimeInterval(timePwdField.text!)
            APPOpertingEnterCommandPrefix.append("2")
            APPOpertingEnterCommandAll = APPOpertingEnterCommandPrefix.appending(NSString.initWith(NSDate(timeIntervalSinceNow: validTime!) as Date!, isRemote: false))
            APPOpertingEnterCommandAll = APPOpertingEnterCommandAll.appending(NSString.convertPassWord(addPwdField.text))
            BluetoothManager.getInstance()?.sendByteCommand(with: APPOpertingEnterCommandAll, deviceID: self.deviceID(with: deviceInfo), sendType: .lock, success: { (data) in
                
            }, fail: { (failCode) -> UInt in
                return 0
            })
        }
        else if indexPath.row==2 {
            //清除密码
            APPOpertingEnterCommandPrefix.append("3")
            APPOpertingEnterCommandAll = APPOpertingEnterCommandPrefix.appending(NSString.initWith(NSDate(timeIntervalSinceNow: 10000) as Date!, isRemote: false))
            APPOpertingEnterCommandAll = APPOpertingEnterCommandAll.appending(NSString.convertPassWord("123456"))
            
            BluetoothManager.getInstance()?.sendByteCommand(with: APPOpertingEnterCommandAll, deviceID: self.deviceID(with: deviceInfo), sendType: .lock, success: { (data) in
                
            }, fail: { (failCode) -> UInt in
                return 0
            })
        }
        else if indexPath.row==3 {
            //同步时间
            APPOpertingEnterCommandPrefix.append("8")
            APPOpertingEnterCommandAll = APPOpertingEnterCommandPrefix.appending(NSString.initWith(Date.init().addingTimeInterval(28800), isRemote: false))
            APPOpertingEnterCommandAll.append("000000000")
            
            BluetoothManager.getInstance()?.sendByteCommand(with: APPOpertingEnterCommandAll, deviceID: self.deviceID(with: deviceInfo), sendType: .lock, success: { (data) in
                
            }, fail: { (failCode) -> UInt in
                return 0
            })
        }
        else if indexPath.row==4 {
            
        }
        
    }
    
    func deviceID(with infoDic:Dictionary<String, Any>) -> String! {
        let advdic=infoDic[AdvertisementData] as! NSDictionary
        let deviceID =  advdic.object(forKey: "kCBAdvDataLocalName") as! String
        let indexOfDeviceID = deviceID.index(deviceID.startIndex, offsetBy: 7)
        let deviceMACID = deviceID.substring(from: indexOfDeviceID)
        return deviceMACID
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
