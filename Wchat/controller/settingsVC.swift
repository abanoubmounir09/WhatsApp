//
//  settingsVC.swift
//  Wchat
//
//  Created by pop on 7/30/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class settingsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return 3
    }

    
      // MARK: - IBActions
    
    @IBAction func LogOutBTNPressed(_ sender: Any) {
        FUser.logoutUser { (success) in
            if success!{
                //go to login View
                self.showLoginView()
            }
        }
    }
    
    func showLoginView(){
      //  let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "welcom")
       let mainView2 = storyboard?.instantiateViewController(identifier: "welcom")
        navigationController?.dismiss(animated: true, completion: {
             self.present(mainView2!, animated: true, completion: nil)
        })
       
    }

}
