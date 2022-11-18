//
//  SearchParameters.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

class SearchParameters {
    var searchCriteria: SearchCriteria
    
    init(searchCriteria: SearchCriteria) {
        self.searchCriteria = searchCriteria
    }
    
    func getQueryParameters() -> [String: Any] {
        var parameters = [String: Any]()
        
        switch searchCriteria {
        case .searchByQuery(let searchQuery):
            if !searchQuery.isEmpty {
                parameters["q"] = searchQuery
            }
        case .searchByAuthorName(let authorName):
            if !authorName.isEmpty {
                parameters["author"] = authorName
            }
        case .searchByDocumentTitle(let documentTitle):
            if !documentTitle.isEmpty {
                parameters["title"] = documentTitle
            }
        }
       
        return parameters
    }
}

enum SearchCriteria {
    case searchByQuery(q: String)
    case searchByAuthorName(authorName: String)
    case searchByDocumentTitle(documentTitle: String)
}
