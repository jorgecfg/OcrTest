//
//  SearchCode.swift
//  OcrTest
//
//  Created by Jorge Flor on 09/07/19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation

class SearchCode {
    private let dataService = DataService()

    func locateCode(_ textRecognized:String) {
        let itens = textRecognized.ocrToArray()
        for item in itens {
            if let brands = dataService.brands {
                if let brand = brands.filter({
                    ($0.name!.contains(item))
                }).first {
                    print("Found Brand: \(brand.name)");
                    for code in itens {
                        if let models = dataService.models {
                            if let model = models.filter({
                                ($0.code!.contains(code)) && $0.brand == brand
                            }).first {
                                print("Found Model Car: \(model.carName)");
                            }
                        }
                    }
                    
                }
                
                
            }
        }
    }
    
    func locateBrand(_ textRecognized:String) {


    }
}
