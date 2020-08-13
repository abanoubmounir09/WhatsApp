//
//  Constatns.swift
//  Wchat
//
//  Created by pop on 7/21/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import Firebase


var RecentBadgeHandler:ListenerRegistration?
let userDefaults = UserDefaults.standard

//MARKE:- notification
public let USER_DID_LOGIN_NOTIFICATION = "UserDidLoginNNotification"
public let APP_STARTED_NOTIFICATION = "AppStartedNotification"


//MARKE:- IDS asn Key
public let kFileReference = ""
public let oneSignalAppID = ""
public let ksinCHSecret = ""
public let KAppUrl = ""

//MARK:_ firebase Header
public let kUser_Path = "user"
public let kTypying_Path = "path"
public let KRecent_Path = "recent"
public let KMessage_Path = "message"
public let KGroup_Path = "group"
public let KCall_Path = "call"

//MARK:_ Fuser
public let kobjectID = "id"
public let kcreatedAt = "createdAt"
public let kupdatedAt = "updatedAt"
public let KpushID = "pushID"
public let kemail = "email"
public let kphoneNumber = "phoneNumber"
public let kcountryCode = "countryCode"
public let kfacebook = "facebook"
public let kloginMethod = "loginMethods"
public let kfirestName = "firestName"
public let klastName = "lastName"
public let kfullName = "fullName"
public let kavatar = "avatar"
public let kisOline = "isActive"
public let kcurrentUser = "currentUser"
public let kcity  = "city"
public let kcountry  = "country"
public let kblockUser = "blockUsers"
public let kVerficationCode = "firebase_verfication"


//MARK:-
public let kbackgroundImage = "backgroundImage"
public let kshowAvatar = "showAvatar"
public let kpasswordProtect = "passwordProtect"
public let kfirstRun = "firstRun"
public let knumberOfMessages = 10
public let kmaxDuration = 120.0
public let kAudioMaxDuration = 10
public let ksuccess = 2

 //MARK:- recent
public let kchatRoomId = "chatRoomId"
public let kuserId = "id"
public let kdate = "date"
public let kprivate = "private"
public let kgroup = "group"
public let kgroupId = "groupId"
public let krecentId = "recentId"
public let kmembers = "members"
public let kmessage = "message"
public let kmembersToPush = "membersToPush"
public let kdescription = "description"
public let klastmesage = "lastmessage"
public let kcounter = "counter"
public let ktype = "type"
public let kuserName = "userName"
public let kuserUserId = "userUserId"
public let kuserUserName = "userUserName"
public let kownerId = "ownerId"
public let kstatus = "status"
public let kmessageId = "messageId"
public let kname = "name"
public let ksenderId = "senderId"
public let ksenderName = "senderName"

public let kmessageName = "messageName"
public let kthumbnail = "thumbnail"
public let kisDeleted = "isDeleted"


 //MARK:- contatct
public let kcontatct = "contacts"
public let kcontatctId = "contatctId"

//MARK:- messages type
public let klocation = "location"
public let kpicture = "picture"
public let ktext = "text"
public let kvideo = "video"
public let kaudio = "audio"

//MARK:- coordinate
public let klattude = "lattude"
public let klongttude = "longttude"

//MARK:- message status
public let kdelivered = "delivered"
public let kread = "read"
public let kreadAt = "readAt"
public let kdeleted = "deleted"

//MARK:- push
public let kdeviceId = "deviceId"

//MARK:- call
public let kisInComing = "deviceId"
public let kcallerId = "callerId"
public let kcallerFullName = "callerFullName"
public let kcallStatus = "callStatus"
public let kwithUserFullName = "withUserFullName"
public let kcallerAvatar = "callerAvatar"
public let kwithUserAvatar = "withUserAvatar"





























































