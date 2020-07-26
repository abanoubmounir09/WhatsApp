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
    
    @IBOutlet weak var passwordTxtF: UITextField!
    
    @IBOutlet weak var repeatPasswprdTxtF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
    //MARK:- IBACTION
    @IBAction func registerBTNPressed(_ sender: Any) {
        dissmisKeyboard()
        if emailTxtF.text != "" , passwordTxtF.text != nil,repeatPasswprdTxtF.text != nil {
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
        FUser.registerUserWith(email: emailTxtF.text!, fname: "", lname: "", pass: passwordTxtF.text!) { (error) in
             if error != nil{
                   self.showAlert("wrong email or password")
                   return
               }else{
                    self.goToApp()
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
        
        // go to App
    }
    
}

