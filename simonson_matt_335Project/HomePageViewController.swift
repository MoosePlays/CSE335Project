//
//  ViewController.swift
//  simonson_matt_335Project
//
//  Created by Michael Figueroa on 4/15/20.
//  Copyright © 2020 mjsimons. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    let coreData = CoreDataManager()
    var imagePicker = UIImagePickerController()
    
    //MARK: - ViewDidLoad stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        let profile = coreData.fetchProfile()
        if profile != []{
            profilePhoto.image = UIImage(data: profile[0].value(forKey: "photo") as! Data, scale: 1.0)
            profileName.text = profile[0].value(forKey: "name") as? String
        }
    }
    
    //MARK: - Edit Button
    @IBAction func editButton(_ sender: Any) {
        let editAlert = UIAlertController(title: "Edit Profile", message: "", preferredStyle: .actionSheet)
        
        //edit photo
        editAlert.addAction(UIAlertAction(title: "Photo", style: .default, handler: {action in
            self.newImage()
        }))
        
        //edit name
        editAlert.addAction(UIAlertAction(title: "Name", style: .default, handler: {action in
            let nameAlert = UIAlertController(title: "Edit Name", message: "", preferredStyle: .alert)
            
            nameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            nameAlert.addTextField(configurationHandler: nil )
            
            nameAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
                
                if let name = nameAlert.textFields?.first?.text {
                    print("New Name: \(name)")
                    
                    self.coreData.setProfileData(name: name, photo: self.profilePhoto.image!.pngData()! as NSData)
                    self.profileName.text = name
                }
            }))
            self.present(nameAlert, animated: true)
        }))
        
        //cancel button
        editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(editAlert, animated: true)
    }
    
    //MARK: - Photo Library Stuff
    func newImage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            coreData.setProfileData(name: profileName.text!, photo: image.pngData()! as NSData)
            profilePhoto.image = image
        }
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
}

