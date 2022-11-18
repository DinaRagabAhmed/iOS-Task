//
//  URLSessionProtocol.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> ()
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
    func cancelAllRequests()
}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
    
    func cancelAllRequests() {
        self.invalidateAndCancel()
    }
}
