//
//  RecentChat.swift
//  Wchat
//
//  Created by pop on 8/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

func startPrivateChat(user1:FUser,user2:FUser)->String{
    let userId1 = user1.objectID
    let userId2 = user2.objectID
    var chatRoomId = ""
    
    let value = userId1!.compare(userId2!).rawValue
    if value < 0 {
        chatRoomId = userId1! + userId2!
    }else{
        chatRoomId = userId2! + userId1!
    }
    
    let members = [userId1!,userId2!]
    
    //  create Recent Chat
    createRecent(members: members, chatRoomId: chatRoomId, withUserName: "", type: "private", users: [user1,user2], avatarGroup: nil)
    
    return chatRoomId
}


    func createRecent(members:[String],chatRoomId:String,withUserName:String,type:String,
                      users:[FUser]?,avatarGroup:String?){
        var tempMembers = members
        
        reference(_collectionRefence: .Recent).whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments { (snapShot, error) in
            
            guard let snapshot = snapShot else{return}
            if !snapShot!.isEmpty{
                for recent in snapshot.documents{
                    let currentRecent = recent.data() as NSDictionary
                    if let curuserId = currentRecent[kuserId]{
                        if tempMembers.contains(curuserId as! String){
                            tempMembers.remove(at: tempMembers.firstIndex(of:curuserId as! String )!)
                        }
                    }
                }
            }
            
            for userId in tempMembers{
                createRecentItems(userId: userId, chatRoomId: chatRoomId, members: members, withUserName: withUserName, type: type, users: users, avatarGroup: avatarGroup)
                
            }
            
        }
    
    
}


func createRecentItems(userId:String,chatRoomId:String,members:[String],withUserName:String,type:String,
users:[FUser]?,avatarGroup:String?){
    
    let localRef = reference(_collectionRefence: .Recent).document()
    let recentId = localRef.documentID
    
    var recent : [String:Any]?
    if type == "private"{
        var withUser:FUser?
        if users != nil && users!.count > 0{
            if userId == FUser.currentUserID(){
                withUser = users?.last
            }else{
                withUser = users?.first
            }
        }
        recent = [krecentId:recentId,kchatRoomId:chatRoomId,kmembers:members,kmembersToPush:members,kuserId:userId, kuserUserName:withUser!.name,kuserUserId:withUser!.objectID,klastmesage:"",kcounter:0,ktype:type]
    }else{
        //grup
         recent = [krecentId:recentId,kchatRoomId:chatRoomId,kmembers:members,kmembersToPush:members,kuserId:userId,kuserUserName:withUserName,klastmesage:"",kcounter:0,ktype:type]
    }
    
    localRef.setData(recent!)
}//end func recent

//delete Recent Chat

func deleteRecentChat(recentChat:NSDictionary){
    if let recentId = recentChat[krecentId] as? String {
        reference(_collectionRefence: .Recent).document(recentId).delete { (error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }else{
                print("chat is deleted")
            }
        }
    }
}

// restart chat
func restartRecentChat(recent:NSDictionary){

    if recent[ktype] as! String == kprivate{

        createRecent(members: recent["membersToPush"] as! [String], chatRoomId: recent["chatRoomId"] as! String, withUserName:FUser.currentUser()!.name!, type: recent["type"] as! String, users:[FUser.currentUser()!], avatarGroup: nil)
            }

   if recent[ktype] as! String == kgroup{
       createRecent(members: recent[kmembersToPush] as! [String], chatRoomId: recent[kchatRoomId] as! String, withUserName: FUser.currentUser()!.name!, type: kgroup, users: nil, avatarGroup: nil)
           }
        
        }
        




