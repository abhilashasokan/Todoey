//
//  ViewController.swift
//  Todoey
//
//  Created by Abhilash on 26/11/18.
//  Copyright © 2018 SweetGodzillas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view, typically from a nib.
        // loadDummyData()
        loadItems()
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.taskName
        cell.accessoryType = item.taskStatus ? .checkmark : .none
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.taskStatus = !item.taskStatus
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Actions that happens when user clicks in alert button
            let newItem = Item()
            newItem.taskName = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // Pass the local variable to functional variable (textField) object
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadDummyData() {
        //tableView.dataSource = itemArray as! UITableViewDataSource
        let newItem = Item()
        newItem.taskName = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.taskName = "Buy Eggs"
        itemArray.append(newItem1)
        let newItem2 = Item()
        newItem2.taskName = "Save the world!"
        itemArray.append(newItem2)
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding item array,\(error)")
            }
        }
    }
}

