//
//  ApprovedListEvidenceViewController.swift
//  WitnessChainPolice
//
//  Created by Dhruv Gupta on 4/18/18.
//  Copyright © 2018 Dhruv Gupta. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI
import Alamofire

class ApprovedListEvidenceViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var EvidenceTableView: UITableView!
    var EvidenceList = [Evidence]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storage = Storage.storage()
    var evidence : Evidence? = nil
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: self.appDelegate.baseUrl + "/public_data")!
        ref = Database.database().reference()
        
        self.EvidenceTableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    ref.child("users").child(self.user!.uid).child("purchased").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                
                print(rest.key)
                
                let parameters = ["contract_address": rest.key]
                
                Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
                    
                    //getting json
                    if let json = response.result.value {
                        
                        //converting json to NSArray
                        let evidenceArray : Dictionary<String, Any>  = json as! Dictionary<String, Any>
                        print(evidenceArray)
                        //traversing through all elements of the array
                        if(((evidenceArray as NSObject).value(forKey: "bought") as! Bool) == true){
                            
                            let blurred_images : Array = (evidenceArray as NSObject).value(forKey: "blurred_images") as! Array<String>
                            let lat : Float = (((evidenceArray) as AnyObject).value(forKey: "latitude") as! Float)/100000
                            let lng : Float = (((evidenceArray) as AnyObject).value(forKey: "longitude") as! Float)/100000
                            let address : String = rest.key
                            let price : Int = (((evidenceArray) as AnyObject).value(forKey: "longitude") as! Int)
                            let receiver : String = (((evidenceArray) as AnyObject).value(forKey: "receiver") as! String)
                            self.EvidenceList.append(Evidence(
                                loc: (lat, lng),
                                images: blurred_images as Array<String>,
                                time: ((evidenceArray as AnyObject).value(forKey: "timestamp") as! Int),
                                address: address,
                                price: price,
                                receiver: receiver
                            ))
                        }
                            
                        //displaying data in tableview
                        self.EvidenceTableView.reloadData()
                    }
                    
                }
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.EvidenceTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EvidenceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EvidenceListViewCell
        self.evidence = EvidenceList[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.labelName.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(Float(evidence!.time!)/10000)))
        cell.labelLoc.text = "\(String(describing: evidence!.loc?.0)), \(String(describing: evidence!.loc?.1))"
        let storageRef = self.storage.reference().child("evidence")
        
        let reference = storageRef.child(evidence!.images![0])
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        cell.evidenceImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "viewapprovedevidence", sender: self)
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "viewapprovedevidence") {
            // get a reference to the second view controller
            let viewEvidenceController = segue.destination as! ViewEvidenceController
            // set a variable in the second view controller with the data to pass
            viewEvidenceController.evidence = self.evidence
            viewEvidenceController.source = "approved"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

