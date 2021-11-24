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
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addFunc))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        nameArry.removeAll()
        idArry.removeAll()
        getData()
    }
    
    @objc func addFunc (){
        performSegue(withIdentifier: "todetailsVC", sender: nil)
    }
    func getData(){
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

}

