//
//  ServiceRequestViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/21/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

class SupportRequestViewController: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ImagePickReceiver {
    
    @IBOutlet weak var product_title: UILabel!
    @IBOutlet weak var issue_description: UITextView!
    @IBOutlet weak var table_container: UIView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var selection: UIPickerView!
    
    static var DESC_FILLER = "Issue Description"
    static var issue_description_text = ""
    static var product: Product = Product(name: "Test", serial: "Test")
    static let issue_types = [
        "Upholstery",
        "Motors and Control",
        "Jets and Pump",
        "Lights",
        "General Electronics",
        "Structure",
        "Other"
    ]
    static var picker_index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if(SupportRequestViewController.product.loaded == false) {
            self.dismiss(animated: true, completion: nil)
        }
        
        issue_description.layer.cornerRadius = 5.0
        issue_description.clipsToBounds = true;
        issue_description.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        issue_description.layer.borderWidth = 0.5
        
        issue_description.text = SupportRequestViewController.DESC_FILLER
        issue_description.textColor = UIColor.lightGray
        issue_description.delegate = self
        
        product_title.text = SupportRequestViewController.product.getGivenName()
        
        selection.dataSource = SupportRequestViewController.issue_types as? UIPickerViewDataSource
        selection.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scroll.contentSize = CGSize(width: scroll.frame.size.width, height: stack.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    @IBAction func sendButtonPressed(_ sender: Any) {
        print("Send button method")
        SupportRequestViewController.picker_index = selection.selectedRow(inComponent: 0)
        SupportRequestViewController.issue_description_text = issue_description.text
        performSegue(withIdentifier: "Send_Email", sender: nil)
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        print("Add image pressed")
        
        
        let alert = UIAlertController(title: "Image Selection", message: "Take image or select image from gallery?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        })
        alert.addAction(UIAlertAction(title: "Take Image", style: .default) { _ in
            print("Take Image")
            ImagePickViewController.picker_type = 1
            self.performSegue(withIdentifier: "PickImage", sender: nil)
            
        })
        alert.addAction(UIAlertAction(title: "Select Image", style: .default) { _ in
            print("Select Image")
            ImagePickViewController.picker_type = 2
            self.performSegue(withIdentifier: "PickImage", sender: nil)
        })
        
        alert.popoverPresentationController?.sourceView = self.view
        present(alert, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondViewController = segue.destination as? ImagePickViewController {
            secondViewController.imagePickReceiver = self
        }
    }
    func imagePickListener(result: Bool, image: UIImage) {
        print("image received in Suport Request")
        //The only child is the image table
        if let table = self.childViewControllers[0] as? ImageTableViewController {
            table.addImage(image: image)
        }
    }
    
    //Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Began Editing")
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Ended Editing")
        SupportRequestViewController.issue_description_text = textView.text
        if textView.text == "" {
            textView.text = SupportRequestViewController.DESC_FILLER
            textView.textColor = UIColor.lightGray
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SupportRequestViewController.issue_types.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SupportRequestViewController.issue_types[row]
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
