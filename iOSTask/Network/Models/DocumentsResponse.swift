//
//  DocumentsResponse.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

class DocumentsResponse: Codable {
    var docs: [Document] = []
    var numFound: Int = 0
}
