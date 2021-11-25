//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Nurşah on 23.11.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArry[indexPath.row]
        return cell
    }
    
    var nameArry = [String]()
    var idArry = [UUID]()
    var selectedPainting = ""
    var selectedPaintingId : UUID?
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addFunc))
        getData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name.init(rawValue: "newData"), object: nil)
    }
    
    @objc func addFunc (){
        selectedPainting = ""
        performSegue(withIdentifier: "todetailsVC", sender: nil)
    }
    @objc func getData(){
        nameArry.removeAll(keepingCapacity: false)
        idArry.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchReq.returnsObjectsAsFaults = false
        do {
           let results = try context.fetch(fetchReq)
            for i in results as! [NSManagedObject]{
                if let name = i.value(forKey: "name") as? String{
                    self.nameArry.append(name)
                }
                if let id = i.value(forKey: "id") as? UUID{
                    self.idArry.append(id)
                }
                self.table.reloadData()
            }
            
        } catch  {
            print("Hata")
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPainting = selectedPainting
            destinationVC.chosenPaintingId = selectedPaintingId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPainting = nameArry[indexPath.row]
        selectedPaintingId = idArry[indexPath.row]
        performSegue(withIdentifier: "todetailsVC", sender: nil)
    }
    
    func tableView(_ tableView : UITableView, commit EditingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if EditingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let idString = idArry[indexPath.row].uuidString
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            fetchReq.predicate = NSPredicate(format: "id = %@", idString)
            fetchReq.returnsObjectsAsFaults = false
            
            do {
               let results = try context.fetch(fetchReq)
                for i in results as! [NSManagedObject]{
                    if let id = i.value(forKey: "id") as? UUID{
                        if id == idArry[indexPath.row] {
                            context.delete(i)
                            nameArry.remove(at: indexPath.row)
                            idArry.remove(at: indexPath.row)
                            self.table.reloadData()
                            do {
                                try context.save()
                            } catch  {
                                print("Error")
                            }
                            break
                        }
                    }
                }
                
            } catch  {
                print("Error")
            }
        }
        
        
    }
}

