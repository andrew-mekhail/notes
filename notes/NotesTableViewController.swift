//
//  ViewController.swift
//  notes
//
//  Created by Andrew Mekhail on 6/3/19.
//  Copyright © 2019 Andrew Mekhail. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController  {

 
    
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
   
        //  if let items = defaults.array(forKey: "Notes Array") as? [String] {
            //        itemArray = items
        //}
        loadItems()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notes Cell", for: indexPath)
        let Item = itemArray[indexPath.row]
        cell.textLabel?.text = Item.titleOfNote
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "GoToDetails" , sender: self)
        saveItems()
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == UITableViewCell.EditingStyle.delete  {
             context.delete(itemArray[indexPath.row])
             itemArray.remove(at: indexPath.row)
             self.tableView.reloadData()
        }
        
    }
    override func prepare(for Segue: UIStoryboardSegue , sender: Any?){
        let destinationVC = Segue.destination as! DetailsOfNoteTableViewController
        if   let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedTitle = itemArray[(indexPath.row)]
        }
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var TextField = UITextField()
        let alert = UIAlertController(title: "Add a new note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add a note", style: .default) { (action) in
           
            let newItem = Item(context:self.context)
            newItem.titleOfNote = TextField.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new note"
            TextField = alertTextField
        }
        alert.addAction(action)
        present(alert , animated: true , completion: nil)
    }
    func saveItems(){
        do {
            try context.save()
        } catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
           itemArray =  try  context.fetch(request)
        } catch {
            print ("error fetching data from context")
        }
    }
    
}


