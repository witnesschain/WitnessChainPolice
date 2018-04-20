//
//  Evidence.swift
//  WitnessChainPolice
//
//  Created by Dhruv Gupta on 4/18/18.
//  Copyright © 2018 Dhruv Gupta. All rights reserved.
//

class Evidence {
    
    var name: String?
    var loc: (Float, Float)?
    var image: String?
    
    init(name: String?, loc: (Float, Float)?, image: String?) {
        self.name = name
        self.loc = loc
        self.image = image
    }
}
