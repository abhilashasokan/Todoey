//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Abhilash on 04/12/18.
//  Copyright © 2018 SweetGodzillas. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK: - Table view Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinatioVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinatioVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Items didnt found.")
        }
        tableView.reloadData()
    }
    
    func saveCategory() {
        do {
            try context.save()
            tableView.reloadData()
        }
        catch {
            print("Error saving context \(error)")
        }
    }
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextbox = UITextField()
        let categoryAlert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            let newCategory = Category(context: self.context)
            newCategory.name = categoryTextbox.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
            self.tableView.reloadData()
        }
        categoryAlert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Category"
            categoryTextbox = alertTextfield
        }
        categoryAlert.addAction(alertAction)
        present(categoryAlert,animated: true, completion: nil)
    }
    
    
    
}
