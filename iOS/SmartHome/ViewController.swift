//
//  ViewController.swift
//  SmartHome
//
//  Created by Ebubekir Ogden on 8/15/17.
//  Copyright © 2017 Ebubekir. All rights reserved.
//

import UIKit

let SERVER_URL = "http://192.168.2.2:3000"

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var buzzerButton: UIButton!
    @IBOutlet weak var electricButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestNotificationAuthorization()
        SetZeroTheApplicationIconBadgeNumber()
        SocketIOManager.sharedInstance.establisConnection()
        
        SocketIOManager.sharedInstance.SOCKET_CONNECTION.on("Temperature"){
            data, ack in
            
            if let temp = data[0] as? Int{
                self.temperatureLabel.text = String(temp)
            }
        }
        
        SocketIOManager.sharedInstance.SOCKET_CONNECTION.on("LedCurrent"){
            data, ack in
            
            print("Led Data is:", data)
            
            if let led = data[0] as? Bool {
                print(led)
                if led{
                    self.lightButton.setTitle("On", for: .normal)
                }
                else{
                    self.lightButton.setTitle("Off", for: .normal)
                }
            }
            
        }
        
        SocketIOManager.sharedInstance.SOCKET_CONNECTION.on("BuzzerCurrent"){
            data, ack in
            
            print("Buzzer Data is:", data);
            
            if let buzzer = data[0] as? Bool {
                if buzzer{
                    self.buzzerButton.setTitle("On", for: .normal)
                }
                else{
                    self.buzzerButton.setTitle("Off", for: .normal)
                }
            }

        }
        
        SocketIOManager.sharedInstance.SOCKET_CONNECTION.on("ElectricCurrent"){
            data, ack in
            
            print("Electric Data is:", data);
            
            if let electric = data[0] as? Bool {
                if electric{
                    self.electricButton.setTitle("On", for: .normal)
                }
                else{
                    self.electricButton.setTitle("Off", for: .normal)
                }
            }
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        SetZeroTheApplicationIconBadgeNumber()
    }

    @IBAction func lightButtonClick(_ sender: Any) {
        SocketIOManager.sharedInstance.SOCKET_CONNECTION.emit("LedSet", with: [])
    }
    @IBAction func buzzerButtonClick(_ sender: Any) {
        SocketIOManager.sharedInstance.SOCKET_CONNECTION.emit("BuzzerSet", with: [])
    }

    @IBAction func electricButtonClick(_ sender: Any) {
        
        SocketIOManager.sharedInstance.SOCKET_CONNECTION.emit("ElectricSet", with: [])
    }
    
}

