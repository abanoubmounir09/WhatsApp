//
//  dateformatterClass.swift
//  Wchat
//
//  Created by pop on 7/25/20.
//  Copyright © 2020 pop. All rights reserved.
//
//
import Foundation
import UIKit
import FirebaseFirestore

let dateformat = "yyyyMMddHHmmss"

func dateFormatter()->DateFormatter{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    dateFormatter.dateFormat = dateformat
    
    return dateFormatter
}

