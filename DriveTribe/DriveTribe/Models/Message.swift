//
//  Message.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/25/21.
//

import Foundation
import MessageKit

// MARK: - Message Properties
struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    
//    enum CodingKeys: String, CodingKey {
//        case sender
//        case messageId
//        case sentDate
//        case kind
//    }
} // END OF STRUCT

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
} // END OF STRUCT

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}




//import UIKit
//import Firebase
//import MessageKit
//
//struct Message {
//
//    var id: String
//    var content: String
//    var created: Timestamp
//    var senderID: String
//    var senderName: String
//
//    var dictionary: [String: Any] {
//
//        return [
//            "id": id,
//            "content": content,
//            "created": created,
//            "senderID": senderID,
//            "senderName":senderName
//        ]
//    }
//}
//
//extension Message {
//    init?(dictionary: [String: Any]) {
//
//        guard let id = dictionary["id"] as? String,
//            let content = dictionary["content"] as? String,
//            let created = dictionary["created"] as? Timestamp,
//            let senderID = dictionary["senderID"] as? String,
//            let senderName = dictionary["senderName"] as? String
//            else {return nil}
//
//        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
//
//    }
//}
//
//extension Message: MessageType {
//
//    var sender: SenderType {
//        return Sender(senderId: senderID, displayName: senderName)
//    }
//
//    var messageId: String {
//        return id
//    }
//
//    var sentDate: Date {
//        return created.dateValue()
//    }
//
//    var kind: MessageKind {
//        return .text(content)
//    }
//}
