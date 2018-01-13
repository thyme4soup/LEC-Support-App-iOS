//
//  EmailViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/13/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    static let BODY_TEMPLATE =
            "[Support Request]\n" +
            "Issue Type: %@\n" +
            "Description:\n%@\n\n" +
            "[Product Info]\n" +
            "%@\n\n" +
            "[Customer Info]\n" +
            "%@\n"

    override func viewDidLoad() {
        super.viewDidLoad()

        sendEmail()
    }

    func sendEmail() {
        let product = SupportRequestViewController.product
        let body = String(format: EmailViewController.BODY_TEMPLATE, SupportRequestViewController.issue_types[SupportRequestViewController.picker_index], SupportRequestViewController.issue_description_text, (product.toLabeledMultiline()), UserInfoTableViewController.getUserInfoAsString())
        print(body)
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the email.
        composeVC.setToRecipients([AppDelegate.SUPPORT_EMAIL])
        composeVC.setSubject("[Support Request]")
        composeVC.setMessageBody(body, isHTML: false)
        
        for (index, image) in ImageTableViewController.images.enumerated() {
            composeVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "image\(index).jpeg")
        }
        ImageTableViewController.images = []
        
        // Present
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services not available")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "UnwindToInfo", sender: nil)
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

}
