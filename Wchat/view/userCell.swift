//
//  userCell.swift
//  Wchat
//
//  Created by pop on 7/30/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class userCell: UITableViewCell {

    
    @IBOutlet weak var UserView: UIView!
    @IBOutlet weak var UserName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    
    func configurecell(fuser:FUser,indexPath:IndexPath){
        UserName.text = fuser.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
