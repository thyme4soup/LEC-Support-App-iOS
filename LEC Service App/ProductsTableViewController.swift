//
//  ProductsViewControllerTableViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/8/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController, UITextFieldDelegate, Notify {
    
    let products_key = "Products"
    
    static var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let products_load = UserDefaults.standard.array(forKey: products_key) as? [String] {
            if !(ProductsTableViewController.products.count > 1) {
                populateProducts(product_list: products_load)
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductsTableViewController.products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)

        // Configure the cell...
        if(ProductsTableViewController.products.count < indexPath.row) {
            print("Table altered during display")
            return cell
        }
        let product = ProductsTableViewController.products[indexPath.row] as Product
        cell.textLabel?.text = product.getTitle()
        cell.detailTextLabel?.text = product.getSubtitle()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        let product = ProductsTableViewController.products[indexPath.row]
        
        let alert = UIAlertController(title: "Product Menu", message: "Options for \"\(product.getTitle())\"", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        })
        alert.addAction(UIAlertAction(title: "Request Support", style: .default) { _ in
            print("Support Requested")
            if UserInfoTableViewController.infoComplete() {
                SupportRequestViewController.product = ProductsTableViewController.products[indexPath.row]
                self.performSegue(withIdentifier: "Request", sender: nil)
            } else {
                let alert = UIAlertController(title: "User Info Incomplete", message: "There's some info to fill out before sending a request", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    self.performSegue(withIdentifier: "InfoUnwind", sender: nil)
                })
                self.present(alert, animated: true)
            }
        })
        alert.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
            print("Rename")
            self.rename(product: product)
        })
        if product.loaded {
            alert.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
            present(alert, animated: true)
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func addProduct(product: Product) {
        if !ProductsTableViewController.exists(serial: product.getSerial()) {
            ProductsTableViewController.products.append(product)
            DispatchQueue.global(qos: .background).async {
                ProductLookup.lookup(serial: product.getSerial(), product: product, notifyOnLookup: self)
            }
            syncTable()
        } else {
            let ac = UIAlertController(title: "Product already exists", message: "This product is already in My Products", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func removeProduct(product: Product) {
        for (index, p) in ProductsTableViewController.products.enumerated() {
            if(p.getSerial() == product.getSerial()) {
                ProductsTableViewController.products.remove(at: index)
                syncTable()
                return
            }
        }
    }
    
    static func getProduct(serial: String) -> Product? {
        for product in products {
            if product.getSerial() == serial {
                return product
            }
        }
        return nil
    }
    
    static func exists(serial: String) -> Bool {
        for product in products {
            if product.getSerial() == serial {
                return true
            }
        }
        return false
    }
    
    func productLookupListener(result: Bool, product: Product) {
        if result == false {
            removeProduct(product: product)
            let ac = UIAlertController(title: "Product not found", message: "Product lookup unsuccessful. Is this a valid barcode?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else if product.name == nil {
            rename(product: product)
        }
        syncTable()
        print("lookup notified")
    }
    
    func populateProducts(product_list: [String]) {
        for product in product_list {
            print(product)
            var info = product.characters.split{$0 == "|"}.map(String.init)
            print(info)
            var name = ""
            var serial = ""
            switch info.count {
            case 1:
                serial = info[0]
                break;
            case 2:
                name = info[0]
                serial = info[1]
                break;
            default:
                break;
            }
            let p = Product(name: name, serial: serial)
            p.info = "Loading..."
            addProduct(product: p)
        }
    }
    func rename(product: Product) {
        //Define product and table
        
        //Get user-defined product name
        let alertController = UIAlertController(title: "Product Name",
                                                message: "Add a personal identifier for the product",
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            let field = alertController.textFields![0]
            product.setName(name: field.text!)
            self.syncTable()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in return }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = product.getGivenName()
            textField.delegate = self
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveProducts() {
        var toSave = [String]()
        for product in ProductsTableViewController.products {
            toSave.append(product.toSaveString())
        }
        UserDefaults.standard.set(toSave, forKey: products_key)
    }
    
    func syncTable() {
        DispatchQueue.main.async {
            ProductsTableViewController.products.sort { (p1, p2) -> Bool in
                p1.getGivenName().lowercased() < p2.getGivenName().lowercased()
            }
            self.tableView.reloadData()
            self.saveProducts()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 25
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source then animate removal
            ProductsTableViewController.products.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveProducts()
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let toMove = ProductsTableViewController.products[fromIndexPath.row]
        ProductsTableViewController.products.remove(at: fromIndexPath.row)
        ProductsTableViewController.products.insert(toMove, at: to.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
