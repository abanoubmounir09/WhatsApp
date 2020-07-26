//
//  FUser.swift
//  Wchat
//
//  Created by pop on 7/21/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FUser{
    
    let objectID:String?
    var pushID:String?
    
    let createdAt:Date?
    let updatedAt:Date?
    
    var email:String?
    var firestName:String?
    var lastName:String?
    var fullName:String?
    var avatar:String?
    var isActive:Bool?
    var phoneNumber:String?
    var countryCode:String?
    var country:String?
    var city:String?
    
    var contacts:[String]
    var blockUsers:[String]
    let loginMethods:String
    
    
    init(_objectID:String,_pushID:String,_createdAt:Date,_updatedAt:Date,_email:String,_firestName:String,_lastName:String,_avatar:String,_isActive:Bool,_phoneNumber:String,_countryCode:String,_country:String,_city:String,_loginMethods:String) {
        
        self.objectID = _objectID
        self.pushID = _pushID
        
        self.createdAt = _createdAt
        self.updatedAt = _updatedAt
        
        self.email = _email
        self.firestName = _firestName
        self.lastName = _lastName
        self.fullName = _firestName + " " + _lastName
        
        self.avatar = _avatar
        self.isActive = true
        
        self.country = _country
        self.city = _city
        self.loginMethods = _loginMethods
        
        self.phoneNumber = _phoneNumber
        self.countryCode = ""

        self.contacts = []
        self.blockUsers = []
    }
    
    init(_ dictionary:NSDictionary) {
        self.objectID = dictionary[kobjectID] as! String
        self.pushID = dictionary[KpushID] as! String
        if let created = dictionary[kcreatedAt] {
            if (created as! String).count != 14 {
                self.createdAt = Date()
            }else{
                self.createdAt = dateFormatter().date(from: (created as? String)!)
            }
        }else{
            self.createdAt = Date()
        }
        
        if let updated = dictionary[kupdatedAt] {
           if (updated as! String).count != 14 {
               self.updatedAt = Date()
           }else{
               self.updatedAt = dateFormatter().date(from: (updated as? String)!)
           }
       }else{
           self.updatedAt = Date()
       }
        
        if let mail = dictionary[kemail] {
            self.email = mail as! String
        }else{
            self.email = ""
        }
        if let fname = dictionary["kfirestName"]{
            self.firestName = fname as! String
        }else{
            self.firestName = ""
        }
        
        if let Lname = dictionary[klastName]{
            self.lastName = Lname as! String
        }else{
            self.lastName = ""
        }
        
        self.fullName = firestName! + "" + lastName!
        
        if let avat = dictionary[kavatar]{
            self.avatar = avat as? String
        }else{
            self.avatar = ""
        }
        
        if let online = dictionary[kisOline]{
            self.isActive = online as! Bool
        }else{
            self.isActive = false
        }
        
        if let phone = dictionary[kphoneNumber]{
            self.phoneNumber = phone as! String
        }else{
            self.phoneNumber = ""
        }
        
        if let countryC = dictionary[kcountryCode]{
               self.countryCode = countryC as! String
           }else{
               self.countryCode = ""
           }
        
        if let Contact = dictionary[kcontatct]{
                self.contacts = Contact as! [String]
            }else{
                self.contacts = []
            }
        
        if let blokcksID = dictionary[kblockUser]{
              self.blockUsers = blokcksID as! [String]
          }else{
              self.blockUsers = []
          }
        
        if let loginMethod = dictionary[kloginMethod]{
             self.loginMethods = loginMethod as! String
         }else{
             self.loginMethods = ""
         }
        
        if let kcity = dictionary[kcity]{
            self.city = kcity as! String
        }else{
            self.city = ""
        }
    }
    
    //MARK:- return current User Methode
     class func currentUserID()->String?{
        if Auth.auth().currentUser?.uid != nil{
            return Auth.auth().currentUser?.uid
        }
        return nil
    }
    
    class func currentUser()->FUser?{
        if Auth.auth().currentUser != nil{
            if let dictionary = userDefaults.object(forKey: "kcurrentUser") {
                return FUser.init(dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //MARK:- llogin method
    
    class func loginUserWith(emil:String,password:String,completion :@escaping(_ error:Error?)->Void ){
        Auth.auth().signIn(withEmail: emil, password: password) { (firuser, error) in
                        if  error != nil{
                completion(error)
            }else{
                //fetch Current user Method
                fetchCurrentUserFromFirestore(userId:firuser!.user.uid)
                completion(error)
            }

        }
    }
    
     //MARK:- create user method
    class func registerUserWith(email:String,fname:String,lname:String,pass:String,avatar:String = "",completion:@escaping(_ error:Error?)->Void){
        
        Auth.auth().createUser(withEmail: email, password: pass) { (firUser, error) in
            if error != nil{
                completion(error)
                return
            }else{
                let fuser = FUser.init(_objectID: (firUser?.user.uid)!, _pushID: "", _createdAt: Date(), _updatedAt: Date(), _email: email, _firestName: fname, _lastName: lname, _avatar: avatar, _isActive: true, _phoneNumber: "", _countryCode: "", _country: "", _city: "", _loginMethods: kemail)
                
                saveUserLocaly(fuser: fuser)
                saveUserToFirestore(fuser:fuser)
                completion(error)
                
            }
        }
    }
    
    //MARK:- llogout
    class func logoutUser(completion:@escaping (_ success:Bool?)->Void){
        userDefaults.removeObject(forKey: KpushID)
      //  removeOneSignalID()
        
        userDefaults.removeObject(forKey: kcurrentUser)
        userDefaults.synchronize()
        
        do {
            try Auth.auth().signOut()
            completion(true)
        }catch{
            completion(false)
            print(error.localizedDescription)
        }
    }
    
     //MARK:- delete User
    class func deleteUser(completion:@escaping (_ success:Bool?)->Void){
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            if error != nil{
                completion(false)
            }else{
                completion(true)
            }
        })
    }
    
}//end class


//MARK:- save user funcs
    func saveUserToFirestore(fuser:FUser){
       reference(_collectionRefence: .User).document(fuser.objectID!).setData(fuser as! [String:Any]) { (error) in
           if error != nil{
               print(error)
               return
           }
       }
   }
   
   func saveUserLocaly(fuser:FUser){
       userDefaults.set(fuser, forKey: kcurrentUser)
   }
   
   //MARK:- fetch user from firestore
   func fetchCurrentUserFromFirestore(userId:String){
       reference(_collectionRefence: .User).document(userId).getDocument { (usersnapShot, error) in
         
           if let userDict = usersnapShot?.exists{
               userDefaults.setValue(usersnapShot?.data() as! NSDictionary, forKey: kcurrentUser)
           }
       }
   }



