//
//  chatsVC.swift
//  Wchat
//
//  Created by pop on 7/30/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class chatsVC: UIViewController,RecentChatDelegate {

    

    @IBOutlet weak var myTableView: UITableView!
    
    //variables
    var recentChat : [NSDictionary] = []
    var realRecentChat: [NSDictionary] = []
    var filterdChat: [NSDictionary] = []
    var recentListner:ListenerRegistration!
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.rowHeight = 90.0
       
        // configure seachrController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecentChat()
        myTableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recentListner.remove()
        realRecentChat.removeAll()
        recentChat.removeAll()
        filterdChat.removeAll()
    }
    
//MARK:- IBActions
    @IBAction func creatNewMessagBTNPressed(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(identifier: "usersTableView")
        navigationController?.pushViewController(mainView!, animated: true)
    }
    
}
 //MARK:- tableview extensin
extension chatsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filterdChat.count
        }else{
             return  realRecentChat.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "recentchat", for: indexPath) as? RecentChatView
        
        var recentChat:NSDictionary!
        
          if searchController.isActive && searchController.searchBar.text != ""{
                 recentChat = filterdChat[indexPath.row]
          }else{
                 recentChat = realRecentChat[indexPath.row]
          }
        
        cell?.configureCell(recentChat: recentChat, indexpath: indexPath)
        cell?.delegate = self
        
        return cell!
    }
    //MARK:- edit row in tableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //
    func tableView(_ tableView: UITableView,
                    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
         let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //code to edit
            print("edited")
                 success(true)
             })
       editAction.backgroundColor = .blue

             return UISwipeActionsConfiguration(actions: [editAction])
     }

     func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
        var tepmChat:NSDictionary!
        
          if searchController.isActive && searchController.searchBar.text != ""{
                 tepmChat = filterdChat[indexPath.row]
          }else{
                 tepmChat = realRecentChat[indexPath.row]
          }
        
        var unMute = "unMute"
        var mute = false
        
        if (tepmChat[kmembersToPush] as! [String]).contains(FUser.currentUserID()!){
             unMute = "mute"
             mute = true
        }
        
       let muteAction = UIContextualAction(style: .normal, title: "mute") { (context, view, success) in
           print("muteAction")
           success(true)
       }
       muteAction.backgroundColor = .green
        
         let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //code to delet
            deleteRecentChat(recentChat: tepmChat)
            self.realRecentChat.remove(at: indexPath.row)
            self.myTableView.reloadData()
            success(true)
         })
         deleteAction.backgroundColor = .red

         return UISwipeActionsConfiguration(actions: [deleteAction,muteAction])
     }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        var tempDict:NSDictionary!
         if searchController.isActive && searchController.searchBar.text != ""{
                tempDict = filterdChat[indexPath.row]
         }else{
                tempDict = realRecentChat[indexPath.row]
         }
        // restart recent chat
             restartRecentChat(recent: tempDict)
        
        // show chat message
        let liveChatOB = liveChatVC()
        liveChatOB.hidesBottomBarWhenPushed = true
        
        liveChatOB.membersToPush = tempDict[kmembersToPush] as! [String]
        liveChatOB.membersIds =  tempDict[kmembers] as! [String]
        liveChatOB.chatRomId =  tempDict[kchatRoomId] as! String
        liveChatOB.name =  tempDict["userUserName"] as! String
        
        navigationController?.pushViewController(liveChatOB, animated: true)
        
    }
    
    //MARK:- Load recentt Chat
    func loadRecentChat(){
        recentListner = reference(_collectionRefence: .Recent).whereField(kuserId, isEqualTo: FUser.currentUserID()).addSnapshotListener({ (snapshot, error) in
            guard let snap = snapshot else{return}
            if !snapshot!.isEmpty{
                let snapShotDict = snapshot?.documentChanges
                snapShotDict?.forEach({ (docchang) in
                    let changDict = docchang.document.data() as! NSDictionary
                    self.recentChat.append(changDict)
                })
                let sortedRecent = self.recentChat as NSArray
                sortedRecent.sortedArray(using: [NSSortDescriptor(key: kuserUserName, ascending: false)]) as! [NSDictionary]
                
                for recent in sortedRecent{
                    let recentDict = recent as? [String:Any]
                    if recentDict?[klastmesage] as? String != "" && recentDict?[kchatRoomId] != nil && recentDict?[krecentId] != nil{
                        self.realRecentChat.append((recentDict as? NSDictionary)!)
                    }
                }
                self.myTableView.reloadData()
            }
        })
    }
    
    //confirm Protocol
    func didTapAvatarPressed(indexpath: IndexPath) {
                
        var recentChat:NSDictionary!
        
          if searchController.isActive && searchController.searchBar.text != ""{
                 recentChat = filterdChat[indexpath.row]
          }else{
                 recentChat = realRecentChat[indexpath.row]
          }

        if recentChat[ktype] as! String == "private"{
            reference(_collectionRefence: .User).document(recentChat[kuserUserId] as! String).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else{return}
                if snapshot.exists{
                    let snapDict = snapshot.data()! as NSDictionary
                    let userOb = FUser(snapDict)
                    self.showUserProfile(user: userOb)
                }
            }
        }
        
    }
    
    func showUserProfile(user:FUser){
        let mainView = storyboard?.instantiateViewController(identifier: "profileView") as! profileVC
        mainView.user = user
        navigationController?.pushViewController(mainView, animated: true)
    }
}

//MARK:- search bar
extension chatsVC:UISearchResultsUpdating{
     
       func filterControlerREsult(searchText:String,scope:String = "All"){
           filterdChat = realRecentChat.filter({ (recentChat) -> Bool in
            return ((recentChat[kuserUserName] as? String)?.lowercased().contains(searchText.lowercased()) ?? false)
           })
           myTableView.reloadData()
       }
       
       func updateSearchResults(for searchController: UISearchController) {
           filterControlerREsult(searchText: searchController.searchBar.text!)
       }
    
    
}
