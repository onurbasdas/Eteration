//
//  CardViewController.swift
//  Eteration
//
//  Created by Onur on 2.02.2024.
//

import UIKit
import SnapKit
import CoreData

class CartViewController: BaseViewController {
    
    // Table view for displaying cart items
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        tableView.tableFooterView = UIView() // To hide empty cell separators
        return tableView
    }()
    
    var cartItems: [CartModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        // Set constraints for table view using SnapKit
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Set the delegate and data source for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    @objc func getData() {
        
        cartItems.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Eteration")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            var uniqueNames: Set<String> = Set()
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String,
                   let price = result.value(forKey: "price") as? String,
                   let id = result.value(forKey: "id") as? UUID {
                    if !uniqueNames.contains(name) {
                        let cartItem = CartModel(name: name, price: price, id: id)
                        cartItems.append(cartItem)
                        uniqueNames.insert(name)
                    }
                }
            }
            tableView.reloadData()
        } catch {
            print("Error")
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = cartItems[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}
