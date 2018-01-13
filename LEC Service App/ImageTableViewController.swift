//
//  ImageTableViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/21/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

class ImageTableViewController: UITableViewController {
    
    static var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Images resets every time a request is opened
        ImageTableViewController.images = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addImage(image: UIImage) {
        ImageTableViewController.images.append(image)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ImageTableViewController.images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ImageItem = tableView.dequeueReusableCell(withIdentifier: "imageItem", for: indexPath) as! ImageItem
        
        // Configure the cell...
        let image = ImageTableViewController.images[indexPath.row]
        cell.myImageName.text = "Image \(indexPath.row)"
        cell.myImageView.image = image
        cell.myItem.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if editingStyle == .delete {
            // Delete the row from the data source
            ImageTableViewController.images.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }

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
