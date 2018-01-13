//
//  ProductLookup.swift
//  LEC Support App
//
//  Created by Michael Chenevey on 6/13/17.
//  Copyright © 2017 Living Earth Crafts. All rights reserved.
//

import Foundation
import UIKit

protocol Lookup {
    var returnProductToCaller: ((Product) -> ())?  { get set }
}
protocol Notify {
    func productLookupListener(result: Bool, product: Product) -> ()
}

class ProductLookup: Lookup {
    
    enum NilError: Error {
        case FoundNil(String)
    }
    
    var returnProductToCaller: ((Product) -> ())?
    
    static func lookup(product: Product, notifyOnLookup: Notify) {
        lookup(serial: product.get(id: "Table Number"), product: product, notifyOnLookup: notifyOnLookup)
    }
    
    static func lookup(serial: String, product: Product, notifyOnLookup: Notify) {
        if let requestURL: NSURL = NSURL(string: "\(AppDelegate.WEB_ADDRESS)?serial=\(serial)") {
            print(requestURL)
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
            let session = URLSession.shared
            let task1 = session.dataTask(with: urlRequest as URLRequest) {
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200) {
                        print("Everyone is fine, file downloaded successfully.")
                        
                        do{
                            
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String:Any]
                            
                            var product_info = [String:String]()
                            
                            for field in Product.fields {
                                if let val = json?[field.id] as? String {
                                    product_info[field.id] = val
                                } else {
                                    print("No String found for field \(field.id)")
                                }
                            }
                            
                            if product.redefine(dict: product_info) {
                                notifyOnLookup.productLookupListener(result: true, product: product)
                            } else {
                                throw NilError.FoundNil("No product of that serial")
                            }
                            
                        } catch {
                            print("Error with Json: \(error)")
                            notifyOnLookup.productLookupListener(result: false, product: product)
                        }
                        
                    } else if error?._code == NSURLErrorTimedOut {
                        print("Timeout on \(serial), reinstancing")
                        lookup(serial: serial, product: product, notifyOnLookup: notifyOnLookup)
                    } else {
                        print("Link broken?")
                        notifyOnLookup.productLookupListener(result: false, product: product)
                    }
                }
            }
            task1.resume()
            
            if let postURL: NSURL = NSURL(string: "\(AppDelegate.WEB_ADDRESS)/register.php?serial=\(serial)&email=\(UserInfoTableViewController.getEmail())") {
                print(postURL)
                let urlPost: NSMutableURLRequest = NSMutableURLRequest(url: postURL as URL)
                let task2 = session.dataTask(with: urlPost as URLRequest) {
                    (data, response, error) -> Void in
                    print(data ?? "No data")
                }
                task2.resume()
            }
        } else {
            notifyOnLookup.productLookupListener(result: false, product: product)
        }
    }
}
