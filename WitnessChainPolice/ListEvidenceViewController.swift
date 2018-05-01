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
    var evidence : Evidence? = nil
    
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
                    
                    let blurred_images : Array = (evidenceArray[i] as! NSObject).value(forKey: "blurred_images") as! Array<String>
                    let lat : Float = (((evidenceArray[i]) as AnyObject).value(forKey: "latitude") as! Float)/100000
                    let lng : Float = (((evidenceArray[i]) as AnyObject).value(forKey: "longitude") as! Float)/100000
                    let address : String = (((evidenceArray[i]) as AnyObject).value(forKey: "address") as! String)
                    let price : Int = (((evidenceArray[i]) as AnyObject).value(forKey: "longitude") as! Int)
                    let receiver : String = (((evidenceArray[i]) as AnyObject).value(forKey: "receiver") as! String)
                    self.EvidenceList.append(Evidence(
                        loc: (lat, lng),
                        images: blurred_images as Array<String>,
                        time: ((evidenceArray[i] as AnyObject).value(forKey: "timestamp") as! Int),
                        address: address,
                        price: price,
                        receiver: receiver
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
        self.evidence = EvidenceList[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.labelName.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(Float(evidence!.time!)/10000)))
        cell.labelLoc.text = "\(String(describing: evidence!.loc?.0 ?? 0.0)), \(String(describing: evidence!.loc?.1 ?? 0.0))"
        let storageRef = self.storage.reference().child("evidence")
        
        let reference = storageRef.child(evidence!.images![0])
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        cell.evidenceImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "showevidence", sender: self)
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showevidence") {
            // get a reference to the second view controller
            let viewEvidenceController = segue.destination as! ViewEvidenceController
            // set a variable in the second view controller with the data to pass
            viewEvidenceController.evidence = self.evidence
            viewEvidenceController.source = "list"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

