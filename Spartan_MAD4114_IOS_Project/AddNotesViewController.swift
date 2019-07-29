//
//  AddNotesViewController.swift
//  Spartan_MAD4114_IOS_Project
//
//  Created by Owner on 2019-07-28.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit
import CoreData

class AddNotesViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pcategory:String?
    var x:String?
    @IBOutlet weak var ndetail: UITextView!
    @IBOutlet weak var ntitle: UITextField!
    let imagePicker = UIImagePickerController()
    var managedObjectContext: NSManagedObjectContext!
     var entry:NSManagedObject!
    
    @IBOutlet weak var image1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let i = x
        {
            self.pcategory = i
        }
        print(pcategory!)
        imagePicker.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
          self.navigationItem.title = "Add Your Notes";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(savenotes))
        // Do any additional setup after loading the view.
    }
    
    @objc func savenotes() {
        let entryEntity = NSEntityDescription.entity(forEntityName: "Notes", in: self.managedObjectContext)!
        let entryObject = NSManagedObject(entity: entryEntity, insertInto: self.managedObjectContext)
         entryObject.setValue(self.pcategory, forKey: "notecategory")
        entryObject.setValue(self.ndetail.text, forKey: "notedetail")
        entryObject.setValue(self.ntitle.text, forKey: "notetitle")
        entryObject.setValue(Date(), forKey: "notedate")
        if image1 != nil {
            let photo = self.image1.image
            let data = photo?.pngData()
            entryObject.setValue(data, forKey: "noteimage")
        }
        
        
        do{
            try managedObjectContext.save()
            print("saved sucessful")
        }catch let error as NSError{
            print("new entry is  not saved \(error.description)")
        }
    }
    func dateWithTime(dates: NSDate)-> String
    {
        let Dated = DateFormatter()
        Dated.dateFormat = "dd/MM/yy/ h:mm:ss a"
        let date = Dated.string(from: dates as Date)
        return date
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func chooseImage(_ sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image1.contentMode = .scaleAspectFit
            image1.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
