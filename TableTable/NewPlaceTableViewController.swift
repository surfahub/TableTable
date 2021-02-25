//
//  NewPlaceTableViewController.swift
//  TableTable
//
//  Created by Surfa on 04.02.2021.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    var currentPlace: Place?
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
 
            let actionSheet = UIAlertController(title:  nil, message: nil, preferredStyle: .actionSheet)
             
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon1 = #imageLiteral(resourceName: "photo-1")
            
            let camera = UIAlertAction(title: "Camera", style: .default)
            { _ in
                self.chooseImagePickerSource(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { (_) in
                self.chooseImagePickerSource(source: .photoLibrary)

            }
            photo.setValue(photoIcon1, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        }
        else {
            view.endEditing(true)
        }
    }
    private func setupEditScreen(){
        
        if currentPlace != nil {
            imageIsChanged = true
            
            editNavigationBar()
            guard let imageData = currentPlace?.imageData, let image = UIImage(data: imageData) else {return}
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            
            
           
        }
        
    }
    private func editNavigationBar(){
        
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    
    
    func savePlace(){

        
        var image: UIImage?

        if imageIsChanged == true {
            image = placeImage.image!
        }
        else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, imageData: imageData)
 
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
            }
        }
        else
        {
        StorageManager.saveObject(newPlace)
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Work with TextFields
extension NewPlaceTableViewController : UITextFieldDelegate {
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
        }
        
    }
}

// MARK: Work with Image

extension NewPlaceTableViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    func chooseImagePickerSource(source: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFit
        placeImage.clipsToBounds = true
        
        imageIsChanged = true

        dismiss(animated: true)
        
    }
}
