//
//  ScanTesseractOcr.swift
//  OcrTest
//
//  Created by Jorge Flor on 09/07/19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation
import TesseractOCR

class ScanTesseractOcr {
    var tesseract:G8Tesseract = G8Tesseract.init(language: "eng")!
    let pages:[G8PageSegmentationMode] = [.auto, .autoOnly, .circleWord, .singleBlock, .singleBlockVertText, .singleChar, .singleColumn, .singleLine, .singleWord, .sparseText]
    
    
    func initTesseract() {
    }
    
    func scheinRecognizeTesseract(_ image: UIImage, page: G8PageSegmentationMode, callback: @escaping(String) -> Void) {
//        tesseract.delegate = ScanTesseractOcr() as! G8TesseractDelegate
        tesseract.image = image
        tesseract.pageSegmentationMode = page
        tesseract.engineMode = .tesseractOnly
        tesseract.charBlacklist = "|,-,},{,[,],*,.,:,;,@,',&,!,?,$,%,(,),‘,_,\\,“"
        tesseract.recognize()

        if let recognizedText = tesseract.recognizedText {
            callback(recognizedText)
        }
    }
    

}

extension G8TesseractDelegate {
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }
}


