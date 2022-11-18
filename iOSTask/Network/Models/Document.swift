//
//  Document.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

class Document: Codable {
    var title: String? = ""
    var isbn: [String]? = []
    var authorName: [String]? = []
    
    enum CodingKeys: String, CodingKey {
        case title
        case isbn
        case authorName = "author_name"
    }
}
