//
//  RoundTXTField.swift
//  Wchat
//
//  Created by pop on 7/26/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class RoundTXTField: UITextField {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = 8
    }

}
