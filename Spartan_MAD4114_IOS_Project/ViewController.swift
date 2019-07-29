//
//  ViewController.swift
//  Spartan_MAD4114_IOS_Project
//
//  Created by Owner on 2019-07-27.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    var text:String?
    var trow:Int?
     var categorylist: [NSManagedObject] = []
    @IBOutlet weak var tbl_category: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        self.tbl_category.delegate=self
        self.tbl_category.dataSource=self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        do {
            categorylist = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction func btn_category_add(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Category", message: "Add a new Category", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tbl_category.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
  
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
        let new_cat = NSManagedObject(entity: entity, insertInto: managedContext)
        new_cat.setValue(name, forKeyPath: "category")
        
        do {
            try managedContext.save()
            categorylist.append(new_cat)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categorylist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categorylist[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "catcell", for: indexPath)
        cell.textLabel?.text = category.value(forKeyPath: "category") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tbl_category.cellForRow(at: indexPath)
          self.text = cell?.textLabel?.text
        self.trow = indexPath.row
        print(trow!)
        print(text!)
        
    }
    
    
    @IBAction func editcategory(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Modify Category", message: "Old Category::"+text!, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first,
            
                let nameToSave = textField.text else {
                    return
            }
            
            self.edit(name: nameToSave)
            self.tbl_category.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func edit(name:String)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format: "category = %@ ",text!)
         fetchRequest1.predicate = NSPredicate(format: "notecategory = %@ ",text!)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results?[0].setValue(name, forKey: "category")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
            tbl_category.reloadData()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
        
        do {
            let results1 = try context.fetch(fetchRequest1) as? [NSManagedObject]
            if results1?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                for i in 0...results1!.count-1
                {
                     results1![i].setValue(name, forKey: "notecategory")
                }
               
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
            tbl_category.reloadData()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    @IBAction func category_delete(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        fetchRequest.predicate = NSPredicate(format: "category = %@ ",text!)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                let objdel = results[0] as! NSManagedObject
                context.delete(objdel)
                self.categorylist.remove(at: trow!)
            
                
            }
         
            
            try context.save()
            self.tbl_category.reloadData()
            
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
        
    }
    
    @IBAction func btn_view_all(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let studentDetailsVC = sb.instantiateViewController(withIdentifier: "viewnotes") as! NotesViewController
        studentDetailsVC.x=text!
        self.navigationController?.pushViewController(studentDetailsVC, animated: true)
        
    }
    
    
}

