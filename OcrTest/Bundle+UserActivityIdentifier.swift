//
//  Bundle+UserActivityIdentifier.swift
//  OcrTest
//
//  Created by Jorge Flor, mVISE AG on 04.07.19.
//  Copyright © 2019 Jorge Flor, mVISE AG. All rights reserved.
//

import Foundation

extension Bundle {
    var userActivityIdentifier: String {
        guard let nsUserActivityTypes = object(forInfoDictionaryKey: "NSUserActivityTypes") as? [String],
            let activityId = nsUserActivityTypes.first else {
                fatalError("Need to declare at least one NSUserActivityTypes in your info.plist")
        }
        return activityId
    }
}
