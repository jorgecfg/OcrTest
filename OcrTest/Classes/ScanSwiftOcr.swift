//
//  ScanSwiftOcr.swift
//  OcrTest
//
//  Created by Jorge Flor on 09/07/19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation
import SwiftOCR

class ScanSwiftOcr {


    func scheinRecognizeSwiftOCR(_ image:UIImage, callback: @escaping (String) -> Void) {
        let swiftOCRInstance = SwiftOCR()
        swiftOCRInstance.recognize(image) { recognizedString in
            callback(recognizedString)
        }
        
        
    }
}
