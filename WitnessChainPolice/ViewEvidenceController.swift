//
//  ViewEvidence.swift
//  WitnessChainPolice
//
//  Created by Dhruv Gupta on 4/21/18.
//  Copyright © 2018 Dhruv Gupta. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI
import ImageSlideshow
import Alamofire

class ViewEvidenceController: UIViewController {
    
    let storage = Storage()
    
    let user = Auth.auth().currentUser
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var evidence : Evidence? = nil
    
    var source: String? = nil
    
    @IBOutlet weak var LocLabel: UILabel!
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var approveButton: UIButton!
    
    @IBOutlet weak var BackButton: UIButton!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        
        TimeLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(Float(evidence!.time!)/10000)))
        LocLabel.text = "\(String(describing: evidence!.loc?.0 ?? 0.0)), \(String(describing: evidence!.loc?.1 ?? 0.0))"
        
        let placeholderImage = UIImage(named: "placeholder.jpg")
        let storageRef = self.storage.reference().child("evidence")
        
        ref = Database.database().reference()
        
        if(source == "approved"){
            print("approved")
            approveButton.isHidden = true
            // ALAMOFIRE PURCHASE
            let parameters : [String:Any] = ["receiver_address": evidence!.receiver!,
                                             "contract_address": evidence!.address!
            ]
            
            let url = URL(string: self.appDelegate.baseUrl + "/preview")!
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value as? [String: Array<String>] {
                    print("JSON: \(json)") // serialized json response
                    var imgSource : [SDWebImageSource] = []

                    for img in json["images"]! {
                        let reference = storageRef.child(img)
                        print(img)
                        self.ImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
                        reference.downloadURL { url, error in
                            if let error = error {
                                // Handle any errors
                                print("error: \(error)")
                            } else {
                                // Get the download URL for 'images/stars.jpg'
                                imgSource.append(SDWebImageSource(url: url!))
                                print("URL: \(String(describing: url))")
                                print("\(imgSource)")
                                self.slideshow.setImageInputs(imgSource)
                            }
                        }

                    }
                    
                }
                progressHUD.hide()
            }
        } else {
            
            print("evidence")
        
            var imgSource : [SDWebImageSource] = []
            
            for img in evidence!.images! {
                let reference = storageRef.child(img)
                print(img)
                ImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
                reference.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print("error: \(error)")
                    } else {
                        // Get the download URL for 'images/stars.jpg'
                        imgSource.append(SDWebImageSource(url: url!))
                        print("URL: \(String(describing: url))")
                        print("\(imgSource)")
                        self.slideshow.setImageInputs(imgSource)
                    }
                }
                
            }
            progressHUD.hide()
        }
        
    }
    @IBAction func GoBack(_ sender: Any) {
        performSegue(withIdentifier: "backfromevidence", sender: nil)
    }
    
    @IBAction func Approve(_ sender: Any) {
        
        let progressHUD = ProgressHUD(text: "Purchasing")
        self.view.addSubview(progressHUD)
        
        // ALAMOFIRE PURCHASE
        let parameters : [String:Any] = ["receiver_address": evidence!.receiver!,
                                         "contract_address": evidence!.address!,
                                         "money_amount": evidence!.price!,
            "money_unit": "wei"
        ]
        
        let url = URL(string: self.appDelegate.baseUrl + "/purchase")!
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            // Add contract to user bought contracts and then list the contracts?
        self.ref.child("users").child(self.user!.uid).child("purchased").child(self.evidence!.address!).setValue(1)
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                //                                self.dismiss(animated: true, completion: nil) // dismiss the image preview somehow
                let alertController = UIAlertController(title: "WitnessChain", message:
                    "Evidence Purchased", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.destructive, handler: {
                    action in                                    self.navigationController?.popViewController(animated: true)
                        self.performSegue(withIdentifier: "backfromevidence", sender: nil)
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
                progressHUD.hide()
            }
        }
    }
    
}
