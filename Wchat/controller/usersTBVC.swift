//
//  usersTBVC.swift
//  Wchat
//
//  Created by pop on 7/30/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class usersTBVC: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var fiterSegmentController: UISegmentedControl!
    
    //VAriables
    var allUsers:[FUser] = []
    var filterdUsers:[FUser] = []
    var allUsersGrouped = NSDictionary() as! [String:[FUser]]
    var sectionTitliesList:[String] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "users"
        tableView.tableFooterView = UIView()
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.rowHeight = 80.0
        
        loadUsers(filterd: kcreatedAt)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        if searchController.isActive  && searchController.searchBar.text != ""{
//            return 1
//        }else{
//            return allUsersGrouped.count
//        }
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         if searchController.isActive  && searchController.searchBar.text != ""{
//            return filterdUsers.count
//           }else{
//            let sectionTitle = self.sectionTitliesList[section]
//
//            let users = self.allUsersGrouped[sectionTitle]
//
//            return users!.count
//           }
        return allUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier:"usercell", for: indexPath) as! userCell
        
        var user:FUser
      
        cell.configurecell(fuser: allUsers[indexPath.row], indexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user2 = allUsers[indexPath.row]

        var userDict:FUser?
        reference(_collectionRefence: .User).document(FUser.currentUserID()!).getDocument { (snap, error) in
            let snapshot = (snap?.data())! as [String:Any]
            let user = FUser(snapshot as NSDictionary)
            userDict = user
            startPrivateChat(user1: userDict!, user2: user2)
        }

    }
    
    
    
    //MARK:- set section Title
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if searchController.isActive  && searchController.searchBar.text != ""{
//         return ""
//        }else{
//         return sectionTitliesList[section]
//        }
//    }
//    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//         if searchController.isActive  && searchController.searchBar.text != ""{
//            return nil
//           }else{
//        return self.sectionTitliesList
//           }
//    }
//    
//    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return index
//    }
    
    func loadUsers(filterd:String?){
        var query:Query?
        
        query = reference(_collectionRefence: .User).order(by: "id", descending: true)
        
        query?.getDocuments(completion: { (snapshot, error) in
            self.allUsers = []
            self.sectionTitliesList = []
            self.allUsersGrouped = [:]
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }else{
                let usersSnapshot = snapshot
                usersSnapshot?.documents.forEach({ (userdict) in
                    let dict = userdict.data() as NSDictionary
                    let fuserOB = FUser(dict)
                    if fuserOB.objectID != FUser.currentUserID(){
                        self.allUsers.append(fuserOB)
                    }
                })
//                self.spliteDAtaIntoSection()
//                self.tableView.reloadData()
            }
            
            self.tableView.reloadData()
            
            
        })
    }
    
    //Mark:- IBACTIONs
    @IBAction func filterdSegementChanged(_ sender: Any) {
        loadUsers(filterd: kupdatedAt)
    }
    
}

extension usersTBVC:UISearchResultsUpdating{
    
    func filterControlerREsult(searchText:String,scope:String = "All"){
        filterdUsers = allUsers.filter({ (user) -> Bool in
            return (user.email!.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterControlerREsult(searchText: searchController.searchBar.text!)
    }
    
     //Mark:- helpersearchFunc
    fileprivate func spliteDAtaIntoSection(){
        var sectionTitle:String = ""
        
        for i in 0..<self.allUsers.count{
            let currentUser = self.allUsers[i]
            let firstChar = currentUser.email?.first!
            let firstCarString = "\(firstChar)"
            
            if firstCarString != sectionTitle{
                sectionTitle = firstCarString
                self.allUsersGrouped[sectionTitle] = []
                self.sectionTitliesList.append(sectionTitle)
            }
            
            self.allUsersGrouped[firstCarString]?.append(currentUser)
            
        }
    }
    
}
