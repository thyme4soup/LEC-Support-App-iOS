//
//  BarcodeViewController.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/12/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, Scanner {
    @IBOutlet weak var back_button: UIButton!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var returnSerialToCaller: ((String) -> ())?
    var highlightView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Image Capture")
        view.backgroundColor = UIColor.black
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =
            [UIViewAutoresizing.flexibleTopMargin,
            UIViewAutoresizing.flexibleBottomMargin,
            UIViewAutoresizing.flexibleLeftMargin,
            UIViewAutoresizing.flexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.green.cgColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            print("videoInput acquired")
        } catch {
            print("failed")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.dismiss(animated: true, completion: nil)
                print("dismissing")
            })
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        self.view.bringSubview(toFront: back_button)
        print("starting")
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        print("object found")
        captureSession.stopRunning()
        var highlightViewRect = CGRect.zero
        
        if let metadataObject = metadataObjects.first {
            
            let obj = self.previewLayer.transformedMetadataObject(for: metadataObject as! AVMetadataMachineReadableCodeObject)
            
            highlightViewRect = ((obj)?.bounds)!
            
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            self.highlightView.frame = highlightViewRect
            self.view.bringSubview(toFront: self.highlightView)
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.dismiss(animated: true)
            found(code: readableObject.stringValue)
            return
        }
        
        self.dismiss(animated: true)
    }
    
    func found(code: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            print("running serial return")
            self.returnSerialToCaller?(code)
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
