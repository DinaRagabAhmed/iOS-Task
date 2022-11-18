//
//  ProviderProtocol.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

protocol ProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> ()) where T: Decodable
    func cancelAllRequests()
}
