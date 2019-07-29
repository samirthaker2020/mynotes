//
//  UpdateNotesViewController.swift
//  Spartan_MAD4114_IOS_Project
//
//  Created by Owner on 2019-07-29.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit
import CoreData
class UpdateNotesViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var pcategory:String?
    var x:Int?
    var y:String?
    var rowno:Int?
    var extitle:String?
    var exdetails:String?
    
    let imagePicker = UIImagePickerController()
    var managedObjectContext: NSManagedObjectContext!
    var entry:NSManagedObject!
    @IBOutlet weak var uimage: UIImageView!
    @IBOutlet weak var unotedetail: UITextView!
    @IBOutlet weak var utitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let i=x
        {
            self.rowno=i
        }
        if let f=y
        {
            exdetails=f
        }
        print(rowno)
         self.imagePicker.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        self.navigationItem.title = "Update Your Notes";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(savenotes))
        // Do any additional setup after loading the view.
    }
    
    @objc func savenotes()
    {
        
    }

    @IBAction func chooseimage(_ sender: Any) {
        
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uimage.contentMode = .scaleAspectFit
            uimage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
