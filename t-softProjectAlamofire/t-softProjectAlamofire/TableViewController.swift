//
//  TableViewController.swift
//  t-softProjectAlamofire
//
//  
//

import Foundation
import CoreData
import UIKit


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    var items: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchItems()
    }
    //bu fonksiyon core datadan aldığı verileri yukarıda tanımladığım items dizisine atar
    func fetchItems() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        
        do {
            items = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    
    // TableView veri kaynağı fonksiyonları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = items[indexPath.row]
        let id = item.value(forKey: "id") as? Int ?? 0
        let title = item.value(forKey: "title") as? String ?? ""
        
        cell.textLabel?.text = "ID: \(id), Title: \(title)"
        
        return cell
    }
}

