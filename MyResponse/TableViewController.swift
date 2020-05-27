//
//  TableViewController.swift
//  MyResponse
//
//  Created by Сергей Цыганков on 27.05.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UINavigationControllerDelegate {

    var responce: Response?
    
    @IBOutlet weak var imageOfObject: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var markSlider: UISlider! {
        didSet {
            markSlider.value = 0
            markSlider.maximumValue = 10
            markSlider.minimumValue = 0
        }
    }
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var colorSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changeMarkAction(_ sender: UISlider) {
        markLabel.text = String(Int(markSlider.value))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        nameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        tableView.tableFooterView = UIView()
        setupEditScreen()
    }
    
    //MARK: - настройка фото
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = UIImage(systemName: "camera")
            let photoIcon = UIImage(systemName: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImagePicker(fromSource: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            
            let photo = UIAlertAction(title: "Библиотека фото", style: .default) { _ in
                self.chooseImagePicker(fromSource: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    //MARK: - настройка сохранения
    func saveObject() {
        let imageData = imageOfObject.image?.pngData()
        let newRespons = Response(name: nameTF.text!, describe: descriptionTF.text, haveColor: colorSwitch.isOn, mark: Int(markSlider.value), imageData: imageData)
        
        if responce != nil {
            try! realm.write {
                responce?.name = newRespons.name
                responce?.describe = newRespons.describe
                responce?.haveColor = newRespons.haveColor
                responce?.mark = newRespons.mark
                responce?.imageData = newRespons.imageData
            }
        } else {
            StorageManager.saveObject(myResponse: newRespons)
        }
    }
    
    //MARK: - настройка редактирования готовой ячейки
    private func setupEditScreen() {
        if responce != nil {
            setupNavigationBar()
            
            guard let data = responce?.imageData, let image = UIImage(data: data) else { return }
            imageOfObject?.image = image
            imageOfObject.contentMode = .scaleAspectFit
            nameTF.text = responce?.name
            descriptionTF.text = responce?.describe
            markLabel.text = String(responce!.mark)
            markSlider.value = Float(responce!.mark)
            colorSwitch.isOn = responce!.haveColor
        }
    }
    
    //MARK: - вклю кнопки сохранения
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil
        title = responce?.name
        saveButton.isEnabled = true
    }
    
    
    
}



//MARK: extencions

extension TableViewController: UIImagePickerControllerDelegate {
    
    func chooseImagePicker(fromSource source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
           
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]){
        imageOfObject.image = info[.editedImage] as? UIImage
        imageOfObject.contentMode = .scaleAspectFill
        imageOfObject.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
}

extension TableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //проверка на вкл/выкл кнопки save
    @objc private func textFieldChanged() {
        if nameTF.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
