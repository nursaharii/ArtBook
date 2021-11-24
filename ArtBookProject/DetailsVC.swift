//
//  DetailsVC.swift
//  ArtBookProject
//
//  Created by Nurşah on 23.11.2021.
//

import UIKit
import CoreData
class DetailsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let dateFormatter = DateFormatter()
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var artist: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
        img.isUserInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(addImg))
        img.addGestureRecognizer(imgTap)
    }
    @objc func addImg(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        img.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func Save(_ sender: Any) {
        dateFormatter.dateFormat = "dd / MM / yyyy"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        let data = img.image?.jpegData(compressionQuality: 0.5)//Sıkıştırma oranı giriyoruz
        
        // Attributes
        newPainting.setValue(name.text!, forKey: "name")
        newPainting.setValue(artist.text!, forKey: "artist")
        newPainting.setValue(date.date, forKey: "year")
        newPainting.setValue(data, forKey: "img")
        newPainting.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
        }
        catch {
            print("Error")
        }
    }
    
    self.navigationController?.popViewController(animated: true)
    
}
