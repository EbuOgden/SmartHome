//
//  NotificationsFunctions.swift
//  Apartments
//
//  Created by Ebubekir Ogden on 7/27/17.
//  Copyright © 2017 Ebubekir. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

func RequestNotificationAuthorization(){
    
    let application = UIApplication.shared
    
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.badge, .alert, .sound]){
        granted, error in
        
        print("Request Notification Authorization GRANTED IS : \(granted)\n");
        
    }
    
    application.registerForRemoteNotifications()
    
}

func IncreaseTheApplicationIconBadgeNumber(_ badgeCount: Int!){
    
    let application = UIApplication.shared
    
    if application.applicationIconBadgeNumber > 20 {
        application.applicationIconBadgeNumber = 1
    }
    else{
        application.applicationIconBadgeNumber += badgeCount
    }
    
    
}

func DecreaseTheApplicationIconBadgeNumber(_ badgeCount: Int){
    
    let application = UIApplication.shared
    
    application.applicationIconBadgeNumber -= badgeCount
    
}

func SetZeroTheApplicationIconBadgeNumber(){
    
    let application = UIApplication.shared
    
    application.applicationIconBadgeNumber = 0
    
    
}

func ShowLocalNotification(_ notifTitle: String!, _ notifBody: String!){
    
    let testIdentifier = "\(Int(arc4random()))"
    
    let localNotification = UNMutableNotificationContent()
    
    localNotification.title = notifTitle
    localNotification.body = notifBody
    localNotification.sound = UNNotificationSound.default()
    
    let request = UNNotificationRequest(identifier: testIdentifier, content: localNotification, trigger: nil);

    UNUserNotificationCenter.current().add(request){
        error in
        
        if (error != nil) {
            print("Error is : ", error ?? "Default Local Notification Error Value");
        }
    }
    
    
}

func RegisterNotificationObserver(_ notificationName: String){
    
    NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil)
}
