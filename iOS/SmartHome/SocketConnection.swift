//
//  SocketConnection.swift
//  Apartments
//
//  Created by Ebubekir Ogden on 7/23/17.
//  Copyright © 2017 Ebubekir. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager{
    
    static let sharedInstance = SocketIOManager()
    
    let SOCKET_CONNECTION = SocketIOClient(socketURL: URL(string: SERVER_URL)!, config: [.forcePolling(true), .forceWebsockets(true)])
    
    let DateController = Date()
    
    private init(){
        
        SOCKET_CONNECTION.on("connect"){
            data, ack in
            
        }
        
        SOCKET_CONNECTION.once("Intruder"){
            data, ack in
            
            ShowLocalNotification("New Alarm!", "Someone Has Been Caught Closer Than 25 cm to Your House.")
            IncreaseTheApplicationIconBadgeNumber(1)
        }
        
        SOCKET_CONNECTION.once("Flame"){
            data, ack in
            
            ShowLocalNotification("New Alarm!", "Fire Has Been Detected.")
            IncreaseTheApplicationIconBadgeNumber(1)
        }
        
        SOCKET_CONNECTION.once("Gas"){
            data, ack in
            
            ShowLocalNotification("New Alarm!", "Gas Leak Has Been Detected. House's Electric System Has Been Shut Down Automaticly.")
            IncreaseTheApplicationIconBadgeNumber(1)
        }
        
        SOCKET_CONNECTION.once("Water"){
            data, ack in
            
            ShowLocalNotification("New Alarm!", "Flood Has Been Detected. House's Electric System Has Been Shut Down Automaticly.")
            IncreaseTheApplicationIconBadgeNumber(1)
        }
        
                
        
        
    }
    
    func establisConnection(){
        SOCKET_CONNECTION.connect()
    }
    
    func closeConnection(){
        SOCKET_CONNECTION.disconnect()
    }
}
