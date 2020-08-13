//
//  IncomingMessages.swift
//  Wchat
//
//  Created by pop on 8/13/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class IncomingMessages{
    var collectionView:JSQMessagesCollectionView?
    
    init(collectionView_:JSQMessagesCollectionView){
        self.collectionView = collectionView_
    }
    
    func createMessage(messageDictionary:NSDictionary,chatRoomId:String)->JSQMessage?{
        var message:JSQMessage?
        let type = messageDictionary[ktype] as? String
        switch type {
        case ktext:
            //
            print("text mesage")
           message = createMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        case kpicture:
            //
             print("text mesage")
        case kaudio:
            //
            print("text mesage")
        case kvideo:
            //
            print("text mesage")
        case klocation:
            print("text mesage")
        default:
            print("undefined message type")
        }
        
        if message != nil{
            return message!
        }else{
            return nil
        }
    }
    
    //create func textMessage
    func createTextMessage(messageDictionary:NSDictionary,chatRoomId:String)->JSQMessage{
        let name = messageDictionary[ksenderName] as? String
        let userId = messageDictionary[ksenderId] as? String
        let text = messageDictionary[kmessage] as? String
        
        var date:Date?
        
        if let createdAt = messageDictionary[kdate] as? String{
            if createdAt.count != 14{
                date = Date()
            }else{
                date = dateFormatter().date(from: createdAt)
            }
        }else{
            date = Date()
        }
        return JSQMessage(senderId: userId, senderDisplayName: name, date: date, text: text)
    }
}
