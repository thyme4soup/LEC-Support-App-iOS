//
//  UserInfoViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/9/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, Notify {

    @IBOutlet weak var request: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func requestButton(_ sender: Any) {
        print("request")
        
        let alert = UIAlertController(title: "Request Support", message: "Do you have the barcode available?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        })
        alert.addAction(UIAlertAction(title: "Scan Item", style: .default) { _ in
            print("Scan")
            self.performSegue(withIdentifier: "Scan", sender: nil)
            
        })
        alert.addAction(UIAlertAction(title: "Select", style: .default) { _ in
            print("Input")
            ProductsViewController.selection = true
            self.performSegue(withIdentifier: "Select", sender: nil)
        })
        alert.popoverPresentationController?.sourceView = request
        present(alert, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var secondViewController = segue.destination as? Scanner {
            print("Going to scanner")
            secondViewController.returnSerialToCaller = receiveSerial
        }
    }
    func productLookupListener(result: Bool, product: Product) {
        print("lookup notified")
        SupportRequestViewController.product = product
        print("product set")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "Request", sender: nil)
        }
        print("segued")
    }
    
    func receiveSerial(serial: String) {
        print("receiving")
        if let product = ProductsTableViewController.getProduct(serial: serial) {
            print("1")
            SupportRequestViewController.product = product
            print("2")
            self.performSegue(withIdentifier: "Request", sender: nil)
            print("segued")
        } else {
            print("3")
            let product = Product(name: serial, serial: serial)
            ProductLookup.lookup(product: product, notifyOnLookup: self)
            print("4")
        }
    }
    
    @IBAction func callButton(_ sender: Any) {
        print("call")
        
        let strPhoneNumber = AppDelegate.SUPPORT_PHONE
        
        if let phoneCallURL:URL = URL(string: "tel:\(strPhoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "Call Direct", message: "Call support at \n\(strPhoneNumber)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    application.open(phoneCallURL)
                })
                let notPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(notPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func sendRequest(segue:UIStoryboardSegue) {
        print("Send unwind")
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        print("Cancel unwind")
    }
    
}
