////
////  finishRegisterVC.swift
////  Wchat
////
////  Created by pop on 7/26/20.
////  Copyright © 2020 pop. All rights reserved.
////
//
//import UIKit
//
//class finishRegisterVC: UIViewController,Alertable {
//    
//     //MARK:- IBOutlets
//    @IBOutlet weak var nameTXTF: RoundTXTField!
//    @IBOutlet weak var surNameTXTF: RoundTXTField!
//    @IBOutlet weak var contryTXTF: RoundTXTField!
//    @IBOutlet weak var phoneTXTF: RoundTXTField!
//    @IBOutlet weak var avatarImgView: UIImageView!
//    @IBOutlet weak var cityTXTF: RoundTXTField!
//    
//    var email:String?
//    var pasword:String?
//    var avatarImg:UIImage?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//    }
//    
//
//  //MARK:- IBActions
//    @IBAction func CAncelBTNPressed(_ sender: Any) {
//        cleanTxtField()
//        dissmisKeyboard()
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func DneBTNPressed(_ sender: Any) {
//        dissmisKeyboard()
//        
//        if nameTXTF.text != "" && surNameTXTF.text != "" && cityTXTF.text != "" && contryTXTF.text != "" && phoneTXTF.text != ""{
//            FUser.registerUserWith(email: email!, fname: nameTXTF.text!, lname: surNameTXTF.text!, pass: pasword!) { (error) in
//                if error != nil{
//                    self.showAlert(error!.localizedDescription)
//                    return
//                }
//                    //success
//                    self.registerUser()
//            }
//        }else{
//            self.showAlert("All Fields needed")
//        }
//    }
//    
//    //MARK:- Helper Function
//    
//    func registerUser(){
//        let fulName = nameTXTF.text! + "" + surNameTXTF.text!
//        
//        let tempDict:Dictionary = [kfirestName:nameTXTF.text!,klastName:surNameTXTF.text!,kfullName:fulName,kcountry:contryTXTF.text!,kcity:cityTXTF.text!,kphoneNumber:phoneTXTF.text!] as [String:Any]
//        
//        finishReister(withvalue: tempDict)
//    }
//    
//    func finishReister(withvalue Dict:[String:Any]){
//        FUser.updateCurrentUserTOFirstore(withdict: Dict) { (error) in
//            if error != nil{
//                self.showAlert(error!.localizedDescription)
//                return
//            }
//        }
//    }
//    
//    func dissmisKeyboard(){
//        view.endEditing(false)
//    }
//    
//    func cleanTxtField(){
//        nameTXTF.text = ""
//        surNameTXTF.text = ""
//        contryTXTF.text = ""
//        cityTXTF.text = ""
//        phoneTXTF.text = ""
//    }
//    
//    func goToApp(){
//           cleanTxtField()
//           dissmisKeyboard()
//           
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kuserId:FUser.currentUserID()])
//           // go to App
//           
//           let mainview = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainApp") as! UITabBarController
//           present(mainview, animated: true, completion: nil)
//       }
//    
//}
