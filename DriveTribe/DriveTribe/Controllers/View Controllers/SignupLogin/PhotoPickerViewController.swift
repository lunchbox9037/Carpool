//
//  PhotoPickerViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/22/21.
//

import UIKit

//MARK: - Protocol
protocol PhotoSelectorViewControllerDelegate: class {
    func photoSelectorViewControllerSelected(image: UIImage)
}//End of protocol

class PhotoPickerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var selectedImage: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedImage.image = UIImage(systemName: "person")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedImage.image = nil
    }
    
    //MARK: - Properties
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    var profilePhoto: UIImage? {
        didSet {
            if profilePhoto != nil {
                loadViewIfNeeded()
                selectedButton.setTitle("", for: .normal)
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func selectedButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    
    
    //MARK: - Methods
    func updateImageView() {
        self.selectedImage.image = profilePhoto
    }
}

//MARK: - Extension (UIImagePickerDelegate)
extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage.image = photo
            delegate?.photoSelectorViewControllerSelected(image: photo)
            selectedButton.setTitle("", for: .normal)
        } else {
            selectedImage.image = UIImage(systemName: "person")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}//End of extension
