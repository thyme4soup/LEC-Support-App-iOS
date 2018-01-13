//
//  ProductsViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/12/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

protocol Scanner {
    var returnSerialToCaller: ((String) -> ())?  { get set }
}

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var back: UIButton!
    static var selection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(ProductsViewController.selection) {
            back.isHidden = false
            ProductsViewController.selection = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addProduct(_ sender: Any) {
        print("add clicked")
        let alert = UIAlertController(title: "Add Item", message: "Do you have the barcode available?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        })
        alert.addAction(UIAlertAction(title: "Scan Item", style: .default) { _ in
            print("Scan")
            self.performSegue(withIdentifier: "Scan", sender: nil)
            
        })
        alert.addAction(UIAlertAction(title: "Manual Input", style: .default) { _ in
            print("Input")
            
            let alertController = UIAlertController(title: "Manual Input",
                                                    message: "Enter your serial below",
                                                    preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                let field = alertController.textFields![0]
                self.receiveSerial(serial: field.text!)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Serial"
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        })
        alert.popoverPresentationController?.sourceView = self.add

        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue preparing")
        if var secondViewController = segue.destination as? Scanner {
            secondViewController.returnSerialToCaller = receiveSerial
            print("prepared")
        } else {
            print("regular segue")
        }
    }
    
    func receiveSerial(serial: String) {
        // add product and send it to get loaded
        print("received serial")
        let table = self.childViewControllers[0] as! ProductsTableViewController
        let p = Product(serial: serial)
        table.addProduct(product: p)
    }
}
