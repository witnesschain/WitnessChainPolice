//
//  EvidenceListViewCell.swift
//  WitnessChainPolice
//
//  Created by Dhruv Gupta on 4/18/18.
//  Copyright © 2018 Dhruv Gupta. All rights reserved.
//

import Foundation

import UIKit

class EvidenceListViewCell: UITableViewCell {
    
    @IBOutlet weak var evidenceImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLoc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
