//
//  RecentChatView.swift
//  Wchat
//
//  Created by pop on 8/2/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

protocol RecentChatDelegate {
    func didTapAvatarPressed(indexpath:IndexPath)
}

class RecentChatView: UITableViewCell {
    
    //IBOUTLETS
    
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var userNameTXTF: UILabel!
    @IBOutlet weak var lastMesgTXTF: UILabel!
    @IBOutlet weak var numberOfMesTXTF: UILabel!
    @IBOutlet weak var mesgBackGroundView: UIView!
    
     //variables
    var indexPath:IndexPath?
    var tapGesture = UITapGestureRecognizer()
    var delegate:RecentChatDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGesture.addTarget(self, action: #selector(self.avatarPressed))
        avatarImgView.isUserInteractionEnabled = true
        avatarImgView.addGestureRecognizer(tapGesture)
    }
    
    
    func configureCell(recentChat:NSDictionary,indexpath:IndexPath){
        self.indexPath = indexpath
        
        self.userNameTXTF.text = recentChat[kuserUserName] as? String
        self.lastMesgTXTF.text = recentChat[klastmesage] as? String
        self.numberOfMesTXTF.text = recentChat[kcounter] as? String
        
        if (recentChat[kcounter] as? Int)! > 0{
            self.numberOfMesTXTF.text = "\(recentChat[kcounter] as? Int)"
            self.mesgBackGroundView.isHidden = false
            self.numberOfMesTXTF.isHidden = false
        }else{
            self.mesgBackGroundView.isHidden = true
             self.numberOfMesTXTF.isHidden = true
        }
        
    }
    
    @objc func avatarPressed(){
        print("tgesture pressed")
        delegate?.didTapAvatarPressed(indexpath: indexPath!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
