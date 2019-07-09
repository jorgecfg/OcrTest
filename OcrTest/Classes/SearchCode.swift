//
//  SearchCode.swift
//  OcrTest
//
//  Created by Jorge Flor on 09/07/19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation

class SearchCode {
    var dataService = DataService()
    
    func locateCode(_ textRecognized:String, brands:[Brand]) -> Model? {
        let brands = locateBrand(textRecognized)
        
        let itens = textRecognized.ocrToArray()
        for brand in brands {
            for code in itens {
                if let models = dataService.models {
                    if let model = models.filter({
                        ($0.code!.contains(code)) && $0.brand == brand
                    }).first {
                        return model
                    }
                }
            }
        }
        return Model()
    }

    
    func locateBrand(_ textRecognized:String) -> [Brand] {
        var brands = [Brand]()
        
        let itens = textRecognized.ocrToArray()
        for item in itens {
            if let brandsSource = dataService.brands {
                if let brand = brandsSource.filter({
                    ($0.name!.contains(item))
                }).first {
                    brands.append(brand)
                }
            }
        }
        return brands
    }
}
