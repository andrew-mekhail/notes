//
//  DetalisOfNoteTableViewController.swift
//  notes
//
//  Created by Andrew Mekhail on 6/4/19.
//  Copyright © 2019 Andrew Mekhail. All rights reserved.
//

import UIKit
import CoreData

class DetailsOfNoteTableViewController: UITableViewController {
  
    
  
    @IBOutlet weak var details: UITextView!
    
  
    
    
    var itemArray = [Item]()
    var selectedTitle : Item?
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
   
         loadItems()
        details.text = selectedTitle?.note
        details.isEditable = true
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func savedButtonPressed(_ sender: Any) {
        selectedTitle?.note = details.text
        saveItems()
    }
    
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
         itemArray =  try  self.context.fetch(request)
        } catch {
            print ("error fetching data from context")
        }
    }
    
    
}
