//
//  ChatViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/25/21.
//

import Foundation
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    // MARK: - Properties
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    var tribe: Carpool?
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let currentUser = UserController.shared.currentUser else {return nil}
        
        let senderID = currentUser.uuid
        
        return Sender(photoURL: "\(senderID).jpeg", senderId: senderID, displayName: "Me")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        
        if let tribeID = tribe?.uuid {
            listenForMessages(id: tribeID, shouldScrollToBottom: true)
        }
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        CarpoolController.shared.getAllMessagesForConversation(with: id) { (result) in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {return}
                let sortedMessages = messages.sorted { (message, message2) -> Bool in
                    return message.sentDate < message2.sentDate
                }
                
                self.messages = sortedMessages
                
                print("made it")
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    
                    if shouldScrollToBottom {
                        self.messagesCollectionView.scrollToLastItem()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}//end class

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("Tapped send")
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let tribe = self.tribe else {return print("no tribe")}
        
        let messageID = UUID().uuidString
        let carpoolID = tribe.uuid
        
        
        
        let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .text(text))
        
        CarpoolController.shared.sendMessage(message: message, carpoolID: carpoolID)
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self sender is nil")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    private func backgroundColor(for message: Message, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
          let sender = message.sender
          if sender.senderId == selfSender?.senderId {
              //our message
              return .link
          }
          return .secondarySystemBackground
    }
    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        let sender = message.sender
//
//
//    }
}
