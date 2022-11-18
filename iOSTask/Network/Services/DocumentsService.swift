//
//  DocumentsService.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

enum DocumentsService: ServiceProtocol {
    
    case getDocuments(parameters: SearchParameters, page: Int, limit: Int)
    
    var baseURL: URL {
        return URL(string: Environment.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getDocuments:
            return "search.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getDocuments:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getDocuments(let searchParameters, let page, let limit):
            var parameters = searchParameters.getQueryParameters()
            parameters["page"] = page
            parameters["limit"] = limit
            print(parameters)
            return .requestParameters(parameters)
        }
    }
    
    var headers: Headers? {
        return nil
    }
    
    var parametersEncoding: ParametersEncoding {
        return .url
    }
}
