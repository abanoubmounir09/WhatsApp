//
//  RoundImage.swift
//  Wchat
//
//  Created by pop on 7/26/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {

     override func awakeFromNib() {
          setupImage()
      }

      func setupImage(){
          self.layer.cornerRadius = self.frame.width / 2
          self.clipsToBounds = true
      }

}
