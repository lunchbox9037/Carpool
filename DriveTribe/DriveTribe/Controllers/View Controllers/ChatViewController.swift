//
//  ChatViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/25/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import JGProgressHUD

class ChatViewController: MessagesViewController {
    // MARK: - Outlets
    @IBOutlet weak var startRouteButton: UIBarButtonItem!
    
    // MARK: - Properties
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    var tribe: Carpool?
    var driver: User?
    var passengers: [User] = []
    private var messages = [MessageType]()
    
    private var imageCache = NSCache<NSString, UIImage>()
    private let spinner = JGProgressHUD(style: .dark)
    
    private var selfSender: Sender? {
        guard let currentUser = UserController.shared.currentUser else {return nil}
        
        let senderID = currentUser.uuid
        
        return Sender(photoURL: "\(senderID).jpeg", senderId: senderID, displayName: currentUser.userName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        messageInputBar.inputTextView.becomeFirstResponder()
        
        fetchDriverAndPassengers()
        setAppearance()
        
        if let tribeID = tribe?.uuid {
            listenForMessages(id: tribeID, shouldScrollToBottom: true)
        }
    }
    
    @IBAction func startRouteButtonTapped(_ sender: Any) {
        guard let tribe = tribe,
              let driver = driver else {return}
        print(tribe.type)
        if tribe.type == "meetup" {
            print("gotmettup route")
            createMeetupRoute(from: tribe, with: driver)
        } else {
            print("gotcarpool route")
            createCarpoolRoute(from: tribe, with: driver, and: self.passengers)
        }
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        spinner.show(in: view)
        CarpoolController.shared.getAllMessagesForConversation(with: id) { [weak self] (result) in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    self?.spinner.dismiss()
                    return
                }
                
                let sortedMessages = messages.sorted { (message, message2) -> Bool in
                    return message.sentDate < message2.sentDate
                }
                
                self?.messages = sortedMessages
                self?.getSenderProfilePics(messages: messages) { [weak self] (result) in
                    switch result {
                    case .success(_):
                        print("made it")
                        DispatchQueue.main.async {
                            self?.spinner.dismiss()
                            self?.messagesCollectionView.reloadDataAndKeepOffset()
                            
                            if shouldScrollToBottom {
                                self?.messagesCollectionView.scrollToLastItem()
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getSenderProfilePics(messages: [Message], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let ids = messages.map {$0.sender.senderId}
        let uniqueIds = Array(Set(ids))
        print(uniqueIds.count)
        for id in uniqueIds {
            StorageController.shared.getImageWith(userID: id) { [weak self] (result) in
                switch result {
                case .success(let image):
                    print("got image")
                    self?.imageCache.setObject(image, forKey: NSString(string: "\(id).jpeg"))
                    return completion(.success(true))
                case .failure(let error):
                    print(error.localizedDescription)
                    return completion(.failure(.noData))
                }
            }
        }
    }//end func
    
    func fetchDriverAndPassengers() {
        guard let carpool = tribe,
              let currentUser = UserController.shared.currentUser else {return}
        //if the carpool is a meetup the driver is always yourself
        if carpool.type == "meetup" {
            self.driver = currentUser
            print(driver?.firstName as Any)
        } else {
            CarpoolController.shared.fetchPassengersIn(carpool: carpool) { [weak self] (result) in
                switch result {
                case .success(let passengers):
                    DispatchQueue.main.async {
                        self?.passengers = passengers
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            CarpoolController.shared.fetchDriverIn(carpool: carpool) { [weak self] (result) in
                switch result {
                case .success(let driver):
                    DispatchQueue.main.async {
                        self?.driver = driver
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
}//end class

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("Tapped send")
        inputBar.inputTextView.text = ""
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
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let currentUser = UserController.shared.currentUser else {return}
        
        let sender = message.sender
        
        if sender.senderId == currentUser.uuid {
            // show our image
            let url = "\(currentUser.uuid).jpeg"
            if let avatarImage = self.imageCache.object(forKey: url as NSString) {
                avatarView.image = avatarImage
                print("used current user cache")
            }
        }
        else {
            let otherUserID = messages[indexPath.section].sender.senderId
            // other user image
            let url = "\(otherUserID).jpeg"
            if let otherUserAvatarImage = self.imageCache.object(forKey: url as NSString) {
                print("used cache")
                avatarView.image = otherUserAvatarImage
            }
        }
    }

//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sender.displayName
//        return NSAttributedString(
//            string: name,
//            attributes: [
//                .font: UIFont.preferredFont(forTextStyle: .caption1),
//                .foregroundColor: UIColor(white: 0.3, alpha: 1)
//            ]
//        )
//    }
//
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 35
//    }
}//end extension
