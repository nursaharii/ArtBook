//
//  DetailsVC.swift
//  ArtBookProject
//
//  Created by Nurşah on 23.11.2021.
//

import UIKit
import CoreData
class DetailsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    let dateFormatter = DateFormatter()
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var artist: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    var chosenPainting = ""
    var chosenPaintingId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenPainting != "" {
            saveBtn.isEnabled = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            let idString = chosenPaintingId?.uuidString
            fetchReq.predicate = NSPredicate(format: "id = %@", idString!)
            fetchReq.returnsObjectsAsFaults = false
            
            do {
               let results = try context.fetch(fetchReq)
                if results.count > 0 {
                    for i in results as! [NSManagedObject] {
                        if let isim = i.value(forKey: "name") as? String{
                            name.text = isim
                        }
                        if let artst = i.value(forKey: "artist") as? String{
                            artist.text = artst
                        }
                        if let imageData = i.value(forKey: "img") as? Data{
                           let image = UIImage(data: imageData)
                            img.image = image
                        }
                        if let dateData = i.value(forKey: "year") as? Date {
                            date.date = dateData
                        }
                    }
                }
            } catch  {
               print("Error")
            }
            
        }
        
        else {
            saveBtn.isEnabled = false
        }
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
        saveBtn.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func Save(_ sender: Any) {
        
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
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
