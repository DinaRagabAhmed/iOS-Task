//
//  NetworkResponse.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
