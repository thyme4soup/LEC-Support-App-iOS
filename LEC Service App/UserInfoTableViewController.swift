//
//  UserInfoTableViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/8/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

class UserInfoTableViewController: UITableViewController, UITextFieldDelegate {
    
    // If more fields are needed change the following value
    static var info_fields = [
        (field: "Name", req: true, in: ""),
        (field: "Email", req: true, in: ""),
        (field: "Phone", req: true, in: ""),
        (field: "Organization", req: false, in: "")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = UserDefaults.standard
        for (index, item) in UserInfoTableViewController.info_fields.enumerated() {
            if let read = prefs.string(forKey: item.field) {
                UserInfoTableViewController.info_fields[index].in = read
            } else {
                UserInfoTableViewController.info_fields[index].in = ""
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserInfoTableViewController.info_fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:InfoField = tableView.dequeueReusableCell(withIdentifier: "infoField", for: indexPath) as! InfoField
    
        // Configure the cell...
        let info = UserInfoTableViewController.info_fields[indexPath.row]
        cell.myInfoLabel.text = info.field
        if(info.req) {
            cell.myInfoInput.placeholder = "Required"
        } else {
            cell.myInfoInput.placeholder = "Optional"
        }
        cell.myInfoInput.text = UserInfoTableViewController.info_fields[indexPath.row].in
        cell.myInfoInput.delegate = self
        cell.myInfoInput.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: - Text Field Handling
    
    func textFieldDidBeginEditing(_ textField: UITextField) {      //delegate method
        print(textField.tag)
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {   //delegate method
        print(textField.tag)
        UserInfoTableViewController.info_fields[textField.tag].in = textField.text!
        UserDefaults.standard.setValue(textField.text!, forKey: UserInfoTableViewController.info_fields[textField.tag].field)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {     //delegate method
        textField.resignFirstResponder()
        return true;
    }
    
    func getUserInfo() -> [(field: String, res: String)] {
        var info = [(String, String)](repeating: ("", ""), count:UserInfoTableViewController.info_fields.count)
        for (index, val) in UserInfoTableViewController.info_fields.enumerated() {
            info[index] = (val.field, val.in)
        }
        return info
    }
    static func getUserInfoAsString() -> String {
        var multi = ""
        for (index, field) in info_fields.enumerated() {
            multi += "\(field.field): \(field.in)"
            if index < info_fields.count - 1 {
                multi += "\n"
            }
        }
        return multi
    }
    static func infoComplete() -> Bool {
        for field in info_fields.enumerated() {
            if field.element.req && !(field.element.in.characters.count > 0) {
                return false
            }
        }
        return true
    }
    static func getEmail() -> String {
        for field in info_fields {
            if field.field == "Email" {
                if field.in.characters.count > 0 {
                    return field.in
                }
            }
        }
        return ""
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
