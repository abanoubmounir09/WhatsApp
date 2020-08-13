//
//  ViewController.swift
//  Wchat
//
//  Created by pop on 7/21/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class WelcomVC: UIViewController,Alertable {
    
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var fullNameTXTF: RoundTXTField!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var repeatPasswprdTxtF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
    //MARK:- IBACTION
    @IBAction func registerBTNPressed(_ sender: Any) {
        dissmisKeyboard()
        if emailTxtF.text != "" ,fullNameTXTF.text != "" ,passwordTxtF.text != nil,repeatPasswprdTxtF.text != nil {
            if passwordTxtF.text == repeatPasswprdTxtF.text{
                  registerUser()
            }else{
                self.showAlert("paswords donot match")
            }
        }else{
             self.showAlert("enter all fields vaild data")
        }
    }
    
    @IBAction func LoginBTNPressed(_ sender: Any) {
        dissmisKeyboard()
        
        if emailTxtF.text != "" , passwordTxtF.text != nil {
            loginUser()
        }else{
            
        }
    }
    
    @IBAction func tapGesturePressed(_ sender: Any) {
        dissmisKeyboard()
    }
    
    func loginUser(){
        FUser.loginUserWith(emil: emailTxtF.text!, password: passwordTxtF.text!) { (error) in
            if error != nil{
                self.showAlert("wrong email or password")
                return
            }else{
                 self.goToApp()
            }
        }
    }
    
    func registerUser(){
        FUser.registerUserWith(email: emailTxtF.text!, pass: passwordTxtF.text!,fullName: fullNameTXTF.text!) { (error) in
             if error != nil{
                   self.showAlert("wrong email or password")
                   return
               }else{
              
                self.goToApp()
                //self.performSegue(withIdentifier: "welcom", sender: self)
               }
        }
    }
    
    //MARK:- Helper Function
    func dissmisKeyboard(){
        view.endEditing(false)
    }
    
    func cleanTxtField(){
        emailTxtF.text = ""
        passwordTxtF.text = ""
        repeatPasswprdTxtF.text = ""
    }
    
    //MARK:- go to App
    
    func goToApp(){
        cleanTxtField()
        dissmisKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kuserId:FUser.currentUserID()])
        // go to App
        
        self.dismiss(animated: true) {
            let mainview = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainApp") as! UITabBarController
            self.present(mainview, animated: true, completion: nil)

//             let mainview = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainApp") as! UITabBarController
//            self.present(mainview, animated: true, completion: nil)
        }
        
       
    }
    
    
    //MARK:- navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "welcom"{
//            let vc = segue.destination as! finishRegisterVC
//            vc.email = emailTxtF.text!
//            vc.pasword = passwordTxtF.text!
//        }
//    }
    
}

