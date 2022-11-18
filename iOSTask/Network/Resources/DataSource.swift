//
//  DataSource.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

class DataSource {
    static func provideNetworkDataSource() -> URLSessionProvider {
        return URLSessionProvider.shared
    }
}
