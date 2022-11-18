//
//  BaseViewModel.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

protocol BaseViewModelOutput {
    var isActivityIndicatorHidden: Observable<Bool> { get }
    var messagesObservable: Observable<String?> { get }
    var errorsObservable: Observable<NetworkError?> { get }
}

class BaseViewModel: BaseViewModelOutput {
    
    var page = 1
    var limit = 10
    var hasMorePages: Bool = false
    let isActivityIndicatorHidden: Observable<Bool> = Observable(true)
    let errorsObservable: Observable<NetworkError?> = Observable(nil)
    let messagesObservable: Observable<String?> = Observable(nil)

    var provider: ProviderProtocol?
    
    init(provider: ProviderProtocol?) {
        self.provider = provider
    }
}
