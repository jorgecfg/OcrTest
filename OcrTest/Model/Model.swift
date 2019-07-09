//
//  Data.swift
//  OcrTest
//
//  Created by Jorge Flor, mVISE AG on 05.07.19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation

class Brand : NSObject{
    var name:String?
    
}

class Model : NSObject{
    var carName:String?
    var code:String?
    var brand:Brand?
}
