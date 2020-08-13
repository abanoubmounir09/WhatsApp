//
//  outGoingMessages.swift
//  Wchat
//
//  Created by pop on 8/8/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation

class outGoingMessages{
    
    let messageDictionary:NSMutableDictionary?
    
    init(message:String,senderID:String,senderName:String,date:Date,status:String,type:String){
        messageDictionary = NSMutableDictionary(objects: [message,senderID,senderName,dateFormatter().string(from: date),status,type], forKeys: [kmessage as NSCopying,ksenderId as NSCopying,ksenderName as NSCopying,kdate as NSCopying,kstatus as NSCopying, ktype as NSCopying])
    }
    
    
    //MARK:- send Message
    func SendMessage(roomId:String,messageDictionary:NSMutableDictionary,membersId:[String],membersToPush:[String]){
        
        let messageId = UUID().uuidString
        messageDictionary[kmessageId] = messageId
        
        for memberId in membersId{
            reference(_collectionRefence: .Message).document(memberId).collection(roomId).document(messageId).setData(messageDictionary as! [String : Any])
        }
        //update last message
        
        // send push notification
    }
    
    
    
}
