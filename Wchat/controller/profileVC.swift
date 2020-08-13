//
//  profileVC.swift
//  Wchat
//
//  Created by pop on 8/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class profileVC: UITableViewController {

    @IBOutlet weak var emailTXTF: UILabel!
    
    @IBOutlet weak var phoneNumberBTN: UIButton!
    
    @IBOutlet weak var messageBTN: UIButton!
    
    @IBOutlet weak var blockUserBTN: UIButton!
    
    var user:FUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 30
        }
    }
    
     //MARK:- setup ui
    func setupUI(){
        if user != nil{
            self.title = "profile"
            emailTXTF.text = user?.email
            updateBlockStatus()
        }
    }

    func updateBlockStatus(){
        if user?.objectID != FUser.currentUserID(){
            blockUserBTN.isHidden = false
            messageBTN.isHidden = false
            phoneNumberBTN.isHidden = false
        }else{
            blockUserBTN.isHidden = true
            messageBTN.isHidden = true
            phoneNumberBTN.isHidden = true
        }
        
//        if (FUser.currentUser()?.blockUsers.contains((user?.objectID)!))!{
//            blockUserBTN.setTitle("UnBlock", for: .normal)
//        }else{
//            blockUserBTN.setTitle("Block", for: .normal)
//        }
    }
    
    //MARK:- IBAction
    
    @IBAction func callBTNPressed(_ sender: Any) {
        
    }
    
    @IBAction func messageBTNPressed(_ sender: Any) {
        
    }
    
    @IBAction func blockUserBTNPressed(_ sender: Any) {
        
    }
}
