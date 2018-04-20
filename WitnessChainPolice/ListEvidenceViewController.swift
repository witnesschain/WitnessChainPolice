//
//  ListEvidenceViewController.swift
//  WitnessChainPolice
//
//  Created by Dhruv Gupta on 4/13/18.
//  Copyright © 2018 Dhruv Gupta. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI
import Alamofire

class ListEvidenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var EvidenceTableView: UITableView!
    var EvidenceList = [Evidence]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: self.appDelegate.baseUrl + "/list_contracts")!

        self.EvidenceTableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        Alamofire.request(url).responseJSON { response in
            
            //getting json
            if let json = response.result.value {
                
                //converting json to NSArray
                let evidenceArray : NSArray  = json as! NSArray
                print(evidenceArray)
                //traversing through all elements of the array
                for i in 0..<evidenceArray.count{
                    
                    
                    var lat : String = (evidenceArray[i] as! Dictionary).value(forKey: "latitude") as! String
                    var lng : String = (evidenceArray[i] as! Dictionary).value(forKey: "longitude") as! String
                    lat.insert(".", at: lat.index(lat.startIndex, offsetBy: -6))
                    lng.insert(".", at: lng.index(lng.startIndex, offsetBy: -6))
                    self.EvidenceList.append(Evidence(
                        name: (evidenceArray[i] as! Dictionary).value(forKey: "name") as? String,
                        loc: (Float(lat), Float(lng)) as? (Float, Float),
                        image: ((evidenceArray[i] as Dictionary).value(forKey: "blurred_images") as! Array)[0] as? String
                    ))
                    
                }
                
                //displaying data in tableview
                self.EvidenceTableView.reloadData()
            }
            
        }
        
        
        
        self.EvidenceTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EvidenceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EvidenceListViewCell
        let evidence: Evidence
        evidence = EvidenceList[indexPath.row]
        
        cell.labelName.text = evidence.name
        cell.labelLoc.text = String(describing: evidence.loc?.0) + "," + String(describing: evidence.loc?.1)
        let storageRef = self.storage.reference().child("evidence")
        
        let reference = storageRef.child(evidence.image!)
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        cell.evidenceImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

