//
//  NotesViewController.swift
//  Spartan_MAD4114_IOS_Project
//
//  Created by Owner on 2019-07-28.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit
import CoreData
class NotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var text:String?
    var trow:Int?
    var x:String?
    var passcategory:String?
    var managedObjectContext: NSManagedObjectContext!
    var entries: [NSManagedObject]!
    @IBOutlet weak var tblnotes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let i = x
        {
            self.passcategory=i
        }
        //print(self.passcategory!)
        self.tblnotes.delegate=self
        self.tblnotes.dataSource=self
        self.navigationItem.title = "All Notes";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Notes", style: .done, target: self, action: #selector(addnotes))
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
//self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchEntries()
    }
    
    // Fetch data
    func dateWithTime(dates: NSDate)-> String
    {
        let Dated = DateFormatter()
        Dated.dateFormat = "dd/MM/yy/ h:mm:ss a"
        let date = Dated.string(from: dates as Date)
        return date
    }
    func fetchEntries()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
         fetchRequest.predicate = NSPredicate(format: "notecategory = %@ ",passcategory!)
        do{
            let entryObjects = try managedObjectContext.fetch(fetchRequest)
            self.entries = entryObjects as! [NSManagedObject]
        }catch let error as NSError{
            print("Entry is not fetched\(error.userInfo)")
        }
        self.tblnotes.reloadData()
    }
    
    
    
    
    @objc func addnotes()
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let studentDetailsVC = sb.instantiateViewController(withIdentifier: "addnotes") as! AddNotesViewController
            studentDetailsVC.x = passcategory!
        self.navigationController?.pushViewController(studentDetailsVC, animated: true)
    }
    @IBAction func backbutton(_ sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
         
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notecell") as! NotesTableViewCell
        
        let m=entries[indexPath.row]
        cell.ntitle.text=m.value(forKey: "notetitle") as? String
        cell.ndetail.text=m.value(forKey: "notedetail") as! String
        
        let entryDate = m.value(forKey: "notedate") as! NSDate
        cell.ndatetime.text = "Created on "+" "+dateWithTime(dates: entryDate)
        if m.value(forKey: "noteimage") != nil {
            cell.nimage?.image = UIImage.init(data: m.value(forKey: "noteimage") as! Data)
        }
        
        print(m.value(forKey: "notetitle") as! String)
        print(m.value(forKey: "notedetail") as! String)
       
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

