//
//  Task.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

typealias Parameters = [String: Any]

enum Task {
    case requestPlain
    case requestParameters(Parameters)
}
