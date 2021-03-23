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
    func storeImage(user: User, completion: @escaping (Result<URL, NetworkError>) -> Void) {
        
        let image = UIImage(systemName: "person")
        guard let data = image?.jpegData(compressionQuality: 0.5) else {return}
        
        let nameRef = storage.reference(withPath: "\(user.uuid).jpeg")
        
        _ = nameRef.putData(data, metadata: nil) { (metadata, error) in
            
            nameRef.downloadURL { (url, error) in
                guard let downloadURL = url else {return}
                
                //SAVE THE File path to User
                // TO DO
                do {
                let urlString = try String(contentsOf: downloadURL)
                    // TO DO : SAVE IN USER PATH
                    print("----------------- urlString:: \(urlString)-----------------\(#function)")
                } catch {
                    
                }
            
                return completion(.success(downloadURL))
            }
        }
    }
    
    func getImage(user: User, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        let islandRef = storage.reference(withPath: "\(user.uuid).jpeg")
        
        islandRef.getData(maxSize: 2 * 3840 * 2160) { data, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                guard let image = UIImage(data: data!) else {return}
                return completion(.success(image))
            }
        }
    }
}


//End of class
