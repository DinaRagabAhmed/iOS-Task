//
//  Environment.swift
//  iOSTask
//
//  Created by Dina Ragab on 16/11/2022.
//

import Foundation

enum Environment {
    
    enum PlistKeys {
        static let BASE_URL = "BASE_URL"
        static let IMAGES_URL = "IMAGES_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let infoDict = Bundle.main.infoDictionary else {
            fatalError("info.Plist file not found")
        }
        return infoDict
    }()
        
    static let baseURL: String = {
        guard let rootURLstring = Environment.infoDictionary[PlistKeys.BASE_URL] as? String else {
            fatalError("Root URL  not set in plist for this environment")
        }
        
        let baseUrl = "https://\(rootURLstring)"
        guard let url = URL(string: baseUrl) else {
            fatalError("Root URL is invalid")
        }
        return url.absoluteString
    }()
    
    static let imagesURL: String = {
        guard let imagesURLString = Environment.infoDictionary[PlistKeys.IMAGES_URL] as? String else {
            fatalError("Images URL not set in plist for this environment")
        }
        let imagesUrl = "https://\(imagesURLString)"
        guard let url = URL(string: imagesUrl) else {
            fatalError("Images URL is invalid")
        }
        return url.absoluteString
    }()

}
