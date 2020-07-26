//
//  collectionRefence.swift
//  Wchat
//
//  Created by pop on 7/25/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FcollectionRefence : String{
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
    
}

func reference(_collectionRefence:FcollectionRefence)->CollectionReference{
    return Firestore.firestore().collection(_collectionRefence.rawValue)
}
