//
//  ViewController.swift
//  Shopping
//
//  Created by Camilo Hernández Guerrero on 26/06/22.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping list"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
        
        let insert = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insert))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [insert, spacer, share]
        navigationController?.isToolbarHidden = false

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func insert() {
        let alertController = UIAlertController(title: "Adding item", message: "Insert a shopping item.", preferredStyle: .alert)
        alertController.addTextField()
        
        let insertItem = UIAlertAction(title: "Insert", style: .default) {
            [weak self, weak alertController] _ in
            guard let item = alertController?.textFields?[0].text else { return }
            
            if !item.isEmpty {
                self?.shoppingList.insert(item, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                let emptyController = UIAlertController(title: "Empty item", message: "Please enter a valid item.", preferredStyle: .alert)
                emptyController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self?.present(emptyController, animated: true)
            }
        }
    
        alertController.addAction(insertItem)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc func clear() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func share() {
        if shoppingList.isEmpty {
            let alertController = UIAlertController(title: "Empty list", message: "Can't share an empty list.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alertController, animated: true)
        } else {
            let shoppingString = shoppingList.joined(separator: "\n")
            let avc = UIActivityViewController(activityItems: [shoppingString], applicationActivities: [])
            avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(avc, animated: true)
        }
    }
}
