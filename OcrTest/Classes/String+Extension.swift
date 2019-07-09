//
//  String+Extension.swift
//  OcrTest
//
//  Created by Jorge Flor, mVISE AG on 05.07.19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation

extension String {
    func ocrToArray() -> [String] {
        var arrayOcr:[String] = [String]()
        for row in splitLines(source: self) {
            for word in splitSpace(source: row) {
                arrayOcr.append(word)
            }
        }
        return arrayOcr
    }
    
    private func splitLines(source:String) -> [String] {
        let arrayOcr = source.components(separatedBy: "\n")
        return arrayOcr
    }
    
    private func splitSpace(source:String) -> [String] {
        let arrayOcr = source.components(separatedBy: " ")
        return arrayOcr
    }
}
