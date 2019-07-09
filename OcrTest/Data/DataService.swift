//
//  DataService.swift
//  OcrTest
//
//  Created by Jorge Flor, mVISE AG on 05.07.19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation

class DataService: NSObject {
    
    var brands:[Brand]?
    var models:[Model]?
    
    func loadData() -> [Model] {
        brands = [Brand]()
        brands?.append(newBrand(name: "BMW"))
        brands?.append(newBrand(name: "VW"))
        brands?.append(newBrand(name: "AUDI"))
        brands?.append(newBrand(name: "FIAT"))
        
        models = [Model]()
        models?.append(newModel(carName: "Golf", code: "AU", brand: findBrand(name: "VW")!))
        models?.append(newModel(carName: "Fiat 500", code: "312", brand: findBrand(name: "FIAT")!))
        models?.append(newModel(carName: "A3", code: "312", brand: findBrand(name: "AUDI")!))
        models?.append(newModel(carName: "118D", code: "1K4", brand: findBrand(name: "BMW")!))
        models?.append(newModel(carName: "118D", code: "1KA", brand: findBrand(name: "BMW")!))
        models?.append(newModel(carName: "A3 LIMOUSINE", code: "8V", brand: findBrand(name: "AUDI")!))
        
        return models!
    }
    
    func findBrand(name:String) -> Brand? {
        if let brandFiltered = brands?.filter({
            ($0.name?.contains(name))!
        }).first {
            return brandFiltered
        }
        
        return nil
    }
    
    func newBrand(name:String) -> Brand {
        let brand = Brand()
        brand.name = name
        return brand
    }

    func newModel(carName: String, code:String, brand:Brand) -> Model {
        let model = Model()
        model.carName = carName
        model.code = code
        model.brand = brand
        return model
    }
}
