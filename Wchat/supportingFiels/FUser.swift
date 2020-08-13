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
  //  var pushID:String?
      var email:String?
     var isActive:Bool?
    
//    let createdAt:Date?
//    let updatedAt:Date?
    
//
//    var firestName:String?
//    var lastName:String?
    var name:String?
//    var avatar:String?
//
//    var phoneNumber:String?
//    var countryCode:String?
//    var country:String?
//    var city:String?
    
    var contacts:[String]
    var blockUsers:[String]
    let loginMethods:String
    
    
    init(_objectID:String,_email:String,_isActive:Bool,_loginMethods:String,_name:String) {
        
        self.objectID = _objectID
      //  self.pushID = _pushID
        self.name = _name
//        self.createdAt = _createdAt
//        self.updatedAt = _updatedAt
        
        self.email = _email
//        self.firestName = ""
//        self.lastName = ""
//        self.fullName = ""
//
//        self.avatar = ""
        self.isActive = true
        
//        self.country = ""
//        self.city = ""
        self.loginMethods = ""
        
//        self.phoneNumber = ""
//        self.countryCode = ""

        self.contacts = []
        self.blockUsers = []
    }
    
    init(_ dictionary:NSDictionary) {
        self.objectID = dictionary[kobjectID] as? String
       // self.pushID = dictionary[KpushID] as! String
        
        if let mail = dictionary["email"] {
            self.email = mail as? String
        }else{
            self.email = ""
        }
        if let fname = dictionary[kuserName]{
            self.name = fname as? String
        }else{
            self.name = "blaaaaa"
        }
//
//        if let Lname = dictionary[klastName]{
//            self.lastName = Lname as! String
//        }else{
        //    self.lastName = ""
//        }
//
      //  self.fullName = ""
//
//        if let avat = dictionary[kavatar]{
//            self.avatar = avat as? String
//        }else{
//            self.avatar = ""
//        }
        
        //        if let created = dictionary["createdAt"] {
        //                self.createdAt = dateFormatter().date(from: created as! String)!
        //        }else{
              //      self.createdAt = Date()
        //        }

        //        if let updated = dictionary[kupdatedAt] {
        //           if (updated as! String).count != 14 {
        //               self.updatedAt = Date()
        //           }else{
        //               self.updatedAt = dateFormatter().date(from: (updated as? String)!)
        //           }
        //       }else{
              //    self.updatedAt = Date()
        //       }
        
        if let online = dictionary[kisOline]{
            self.isActive = online as? Bool
        }else{
            self.isActive = false
        }

      
         //   self.phoneNumber = ""
        

       
           //    self.countryCode = ""
           

     
                self.contacts = []
            

       
              self.blockUsers = []
          

             self.loginMethods = ""
         

         //   self.city = ""
        
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
            if  let dectionary = userDefaults.object(forKey: kcurrentUser){
                return FUser(dectionary as! NSDictionary)
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
    class func registerUserWith(email:String,pass:String,avatar:String = "",fullName:String,completion:@escaping(_ error:Error?)->Void){
        
        Auth.auth().createUser(withEmail: email, password: pass) { (firUser, error) in
            if error != nil{
                completion(error)
                return
            }else{
                let fuserob = FUser.init(_objectID: (firUser?.user.uid)!, _email: email, _isActive: true, _loginMethods: kemail, _name: fullName)
                
                saveUserLocaly(fuser: fuserob)
                saveUserToFirestore(fuser:fuserob,name:fullName)
                completion(error)
                
            }
        }
    }
    
    class func updateCurrentUserTOFirstore(withdict value:[String:Any],completion:@escaping(_ error:Error?)->Void){
        if let dictionary = userDefaults.object(forKey: kcurrentUser){
            var tempWithValue = value
            let currentUserID = FUser.currentUserID()
            let updatedAt = dateFormatter().string(from: Date())
            tempWithValue[kupdatedAt] = updatedAt
            
            let userObject = (dictionary as? NSDictionary)?.mutableCopy() as? NSMutableDictionary
            
            userObject?.setValuesForKeys(tempWithValue)
            
            reference(_collectionRefence: .User).document(currentUserID!).updateData(tempWithValue) { (error) in
                if error != nil{
                    completion(error)
                    return
                }
                
                // update
                userDefaults.set(tempWithValue, forKey: kcurrentUser)
                userDefaults.synchronize()
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
    func saveUserToFirestore(fuser:FUser,name:String){
        
        let data = ["id":fuser.objectID,kuserName:name,"email":fuser.email,"isActive":fuser.isActive] as [String : Any]
        reference(_collectionRefence: .User).document(fuser.objectID!).setData(data, completion: { (error) in
            if error != nil{
                print(error)
                return
            }else{
                userDefaults.set(fuser, forKey: kcurrentUser)
                print("suces stored to firestore")
            }
        })
   }
   
   func saveUserLocaly(fuser:FUser){
       userDefaults.set(fuser, forKey: kcurrentUser)
   }
   
   //MARK:- fetch user from firestore
   func fetchCurrentUserFromFirestore(userId:String){
       reference(_collectionRefence: .User).document(userId).getDocument { (usersnapShot, error) in
           if let userDict = usersnapShot?.exists{
            userDefaults.setValue(usersnapShot!.data() as NSDictionary?, forKey: kcurrentUser)
           // userDefaults.setValue(userId as String, forKey: kcurrentUser)
           }
       }
   }



