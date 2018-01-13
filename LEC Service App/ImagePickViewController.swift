//
//  ImagePickViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/22/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import UIKit

protocol ImagePickReceiver {
    func imagePickListener(result: Bool, image: UIImage) -> ()
}

class ImagePickViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var picker: UIImagePickerController? = UIImagePickerController()
    var imagePickReceiver: ImagePickReceiver?
    static var picker_type = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        picker?.delegate = self
        print("presented?")
        
        // Add the actions
        switch(ImagePickViewController.picker_type) {
        case 1:
            print("Take Photo")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.openCamera()
            })
            break;
        case 2:
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.openGallery()
            })
            print("Gallery Selection")
            break;
        default:
            print("Unexpected Value, dismissing...")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.dismiss(animated: true, completion: nil)
            })
            break;
        }
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker!, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "This device doesn't have a camera", preferredStyle: UIAlertControllerStyle.alert)
            alertWarning.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    func openGallery() {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker!, animated: true, completion: nil)
    }
    
    
    // MARK: - PickerView Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("Image found")
            self.dismiss(animated: true, completion: nil)
            imagePickReceiver!.imagePickListener(result: true, image: image)
        } else {
            print("No image found")
            self.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancel.")
        picker.dismiss(animated: false, completion: nil)
        self.dismiss(animated:true, completion: nil)
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
