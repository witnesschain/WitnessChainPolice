//
//  Evidence.swift
//  WitnessChainPolice
//
//  Created by Dhruv Gupta on 4/18/18.
//  Copyright © 2018 Dhruv Gupta. All rights reserved.
//

class Evidence {
    
    var loc: (Float, Float)?
    var images: Array<String>?
    var time: Int?
    var address: String?
    var price: Int?
    var receiver: String?
    
    init(loc: (Float, Float)?, images: Array<String>?, time: Int?, address: String?, price: Int?, receiver: String?) {
        self.loc = loc
        self.images = images
        self.time = time
        self.address = address
        self.price = price
        self.receiver = receiver
        
    }
}
