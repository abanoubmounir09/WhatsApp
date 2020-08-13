//
//  liveChatVC.swift
//  Wchat
//
//  Created by pop on 8/4/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MBProgressHUD
import IQAudioRecorderController
import IDMPhotoBrowser
import AVKit
import Firebase

class liveChatVC: JSQMessagesViewController {

    var outGoingBuble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: .blue)
    var InGoingBuble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: .green)
    
    var username:String?
    var chatRomId:String?
    var membersIds:[String]?
    var membersToPush:[String]?
    var name:String?
    var messageArray:[NSDictionary]?
    var messagesType = [kaudio,kvideo,ktext,klocation,kpicture]
    var allMessages:[JSQMessage] = []
    var objectMessages:[NSDictionary] = []
    var loadedMessages:[NSDictionary] = []
    var allPicturesMessages:[String] = []
    var initialLoadCompleted = false
    
    //fix iphone x
    override func viewDidLayoutSubviews() {
        perform(Selector(("jsq_updateCollectionViewInsets")))
    }
     //fix iphone x
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(self.backAction))
        navigationItem.title = name!
        
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.senderId =  FUser.currentUserID()!
        self.senderDisplayName = FUser.currentUser()?.name
       
        //fix iphone x
        let constraint = perform(Selector(("toolbarBottomLayoutGuide")))?.takeUnretainedValue() as! NSLayoutConstraint

        constraint.priority = UILayoutPriority(rawValue: 1000)

        self.inputToolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //end fix
        
        //custom send button
        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "mic"), for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
    }
    
    //MARK:- JSQ MEssages Delegate
    //attachment button
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            print("Camera")
        }
        
        let PhotoLibrary = UIAlertAction(title: "PhotoLibrary", style: .default) { (action) in
                    print("PhotoLibrary")
        }
        
        let VideoLibrary = UIAlertAction(title: "VideoLibrary", style: .default) { (action) in
                    print("VideoLibrary")
        }
        
        let ShareLocation = UIAlertAction(title: "ShareLocation", style: .default) { (action) in
                    print("ShareLocation")
        }
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        cameraAction.setValue(UIImage(named: ""), forKey: "image")
        PhotoLibrary.setValue(UIImage(named: ""), forKey: "image")
        VideoLibrary.setValue(UIImage(named: ""), forKey: "image")
        ShareLocation.setValue(UIImage(named: ""), forKey: "image")
        
        //add images to action
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(PhotoLibrary)
        optionMenu.addAction(VideoLibrary)
        optionMenu.addAction(ShareLocation)
        optionMenu.addAction(Cancel)
        
        //for ipad
        if(UI_USER_INTERFACE_IDIOM() == .pad){
            if let currentPopUpPresentingController = optionMenu.popoverPresentationController{
                currentPopUpPresentingController.sourceView = self.inputToolbar.contentView.leftBarButtonItem
                currentPopUpPresentingController.sourceRect = self.inputToolbar.contentView.leftBarButtonItem.bounds
                
                currentPopUpPresentingController.permittedArrowDirections = .up
                self.present(optionMenu, animated: true, completion: nil)
            }else{// for iphone
                self.present(optionMenu, animated: true, completion: nil)
            }
        }
       
        
    }
    
    //sendButtoon
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        if text != ""{
            self.sendMessage(text: text, date: date, image: nil, location: nil, video: nil, audio: nil)
            updateSendButton(isSend: false)
            
        }else{
            updateSendButton(isSend: true)
        }
 
    }
    
     //MARK:- send Message
    func sendMessage(text:String?,date:Date?,image:UIImage?,location:String?,video:NSURL?,audio:String?){
        var outGoingMessage : outGoingMessages?
        let currentUser = FUser.currentUser()!
        //text message
        if let text = text{
            outGoingMessage = outGoingMessages(message: text, senderID: currentUser.objectID!, senderName: currentUser.name!, date: date!, status: kdelivered, type: ktext)
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        //clear textField
        self.finishSendingMessage()
        
        outGoingMessage!.SendMessage(roomId: chatRomId!, messageDictionary: (outGoingMessage?.messageDictionary)!, membersId: membersIds!, membersToPush: membersToPush!)
    }
    
    //MARK:- load message from firestore
    func loadMessage(){
        // get last 11 messages
        reference(_collectionRefence: .Message).document(FUser.currentUserID()!).collection(chatRomId!).order(by: kdate, descending: true).limit(to: 11).getDocuments { (snapShot, error) in
            guard let snapshot = snapShot
                else{
                    self.initialLoadCompleted = true
                return
            }
            
            for dict in snapshot.documentChanges{
                var changDict = dict.document.data()
                self.messageArray?.append(changDict as NSDictionary)
            }
            //sortedMessages
            let sortedMessages = self.messageArray as! NSArray
            sortedMessages.sortedArray(using: [NSSortDescriptor(key: kdate, ascending: true)])
            //remove baad messages
            self.loadedMessages = self.removerBadMessages(allMessages: (sortedMessages as? [NSDictionary])!)
            // inser Messages or converted them to jsqmessage
             self.initialLoadCompleted = true
            
            // get pictures messages
            
            // get older mesages in background
            // start listen for new chats
            
        }
    }
    
     //MARK:- backButton Action
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- update send Button
    func updateSendButton(isSend:Bool){
        if isSend == true{
            self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "send"), for: .normal)
        }else{
            self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "mic"), for: .normal)
        }
    }
    
    //MARK:- helper func
    func removerBadMessages(allMessages:[NSDictionary])->[NSDictionary]{
        var tempMessages = allMessages
        
        for message in tempMessages{
            if message[ktype] != nil{
                if !messagesType.contains( message[ktype] as! String){
                    tempMessages.remove(at: tempMessages.index(of:message)!)
                }
            }else{
                 tempMessages.remove(at: tempMessages.index(of:message)!)
            }
        }
        return tempMessages
    }
    
    ///MARK:- textField Delegate
    override func textViewDidChange(_ textView: UITextView) {
        if textView.text != ""{
             updateSendButton(isSend: true)
        }else{
             updateSendButton(isSend: false)
        }
       
    }

}
