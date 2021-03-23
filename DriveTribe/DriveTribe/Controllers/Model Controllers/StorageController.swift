//
//  StorageController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/22/21.
//

import UIKit
import FirebaseStorage

class StorageController {
    
    //MARK: - Properties
    static let shared = StorageController()
    let storage = Storage.storage()
    
    //MARK: - Methods
    func storeImage(user: User, image: UIImage, completion: @escaping (Result<URL, NetworkError>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {return}
        let imageRef = storage.reference(withPath: "\(user.uuid).jpeg")
        _ = imageRef.putData(data, metadata: nil) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {return}
                
                return completion(.success(downloadURL))
            }
        }
    }
    
    func getImage(user: User, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let imageRef = storage.reference(withPath: "\(user.uuid).jpeg")
        imageRef.getData(maxSize: 2 * 3840 * 2160) { data, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                guard let image = UIImage(data: data!) else {return}
                return completion(.success(image))
            }
        }
    }
    
    func deleteImage(user: User, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let imageRef = storage.reference(withPath: "\(user.uuid).jpeg")
        imageRef.delete { error in
            if let error = error {
                print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
            } else {
                print("\n===== SUCCESSFULLY! DELETED PROFILE IMAGE FROM \(user.userName) =====\n")
            }
        }
    }
}


//End of class
