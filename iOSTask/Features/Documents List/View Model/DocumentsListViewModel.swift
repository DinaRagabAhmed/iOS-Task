//
//  DocumentsListViewModel.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

// MARK: - View Model Inputs
protocol DocumentsListViewModelInput {
    func validateSearchParameters(searchCriteria: SearchCriteria)
    func didLoadNextPage()
    func didSelectItem(at index: Int)
    func didChangeSearchQuery(searchBarText: String)
    func didSubmitSearch(searchBarText: String)
}

// MARK: - View Model Outputs
protocol DocumentsListViewModelOutput {
    var documents: Observable<[Document]> { get }
    var paginationOption: Observable<PaginationOptions?> { get }
    var redirection: Observable<DocumentListRedirectionTypes?> { get }
    var screenStatus: Observable<ScreenStatus?> { get }
    var query: Observable<String> { get }
}

protocol DocumentsListViewModelProtocol: DocumentsListViewModelInput, DocumentsListViewModelOutput {}

class DocumentsListViewModel: BaseViewModel, DocumentsListViewModelProtocol {
    
    let documents: Observable<[Document]> = Observable([])
    let paginationOption: Observable<PaginationOptions?> = Observable(.none)
    let redirection: Observable<DocumentListRedirectionTypes?> = Observable(nil)
    let screenStatus: Observable<ScreenStatus?> = Observable(nil)
    let query: Observable<String> = Observable("")
    
    var searchCriteria: SearchCriteria = .searchByQuery(q: "")
    
    
    func didSubmitSearch(searchBarText: String) {
        switch searchCriteria {
        case .searchByQuery:
            self.validateSearchParameters(searchCriteria: .searchByQuery(q: searchBarText))
        case .searchByAuthorName:
            self.validateSearchParameters(searchCriteria: .searchByAuthorName(authorName: searchBarText))
        case .searchByDocumentTitle:
            self.validateSearchParameters(searchCriteria: .searchByDocumentTitle(documentTitle: searchBarText))
        }
    }
    
    // Validate search parameters before setup search request
    func validateSearchParameters(searchCriteria: SearchCriteria) {
        print("did Search")
        switch searchCriteria {
        case .searchByQuery(let query):
            if query.isEmpty {
                resetPages()
                self.messagesObservable.value = "searchEmptyError".localized()
                return
            }
        case .searchByAuthorName(let authorName):
            guard !authorName.isEmpty else { return }
            print("update search bar")
            self.query.value = authorName
            
        case .searchByDocumentTitle(let documentTitle):
            guard !documentTitle.isEmpty else { return }
            print("update search bar")
            self.query.value = documentTitle
        }
        
        self.searchCriteria = searchCriteria
        self.setupSearchRquest(searchCriteria: searchCriteria)
    }
    
    // Setup search request before calling API
    func setupSearchRquest(searchCriteria: SearchCriteria) {
        self.provider?.cancelAllRequests()
        self.resetPages()
        self.getDocuments(searchCriteria: searchCriteria, loading: .firstPage)
    }
    
    // Calling documents API
    func getDocuments(searchCriteria: SearchCriteria, loading: PaginationOptions) {
        
        if Utils.isConnectedToNetwork() {
            if page == 1 {
                // Show loading in first page only
                self.isActivityIndicatorHidden.value = false
            }
            self.paginationOption.value = loading
            print("Value: Loading")
            self.screenStatus.value = .loading
            
            let searchParameters = SearchParameters(searchCriteria: searchCriteria)
            provider?.request(type: DocumentsResponse.self,
                              service: DocumentsService.getDocuments(parameters: searchParameters,
                                                                     page: self.page,
                                                                     limit: self.limit)) { [weak self] response in
                guard let self = self else { return }
                self.paginationOption.value = .none
                print("Value: None")
                self.isActivityIndicatorHidden.value = true
                switch response {
                case let .success(documentsResponse):
                    print("success network")
                    self.handlePagination(result: documentsResponse)
                case let .failure(error):
                    print(error)
                    if !Utils.isConnectedToNetwork() {
                        self.errorsObservable.value = .networkError
                    } else {
                        self.errorsObservable.value = .generalError
                    }
                }
            }
        } else {
            self.errorsObservable.value = .networkError
            
        }
    }

    func didLoadNextPage() {
        print("did load next page")
        guard hasMorePages, paginationOption.value == .none else { return }
        getDocuments(searchCriteria: searchCriteria, loading: .nextPage)
    }
    
    func handlePagination(result: DocumentsResponse) {
        var documents = self.documents.value
        
        if( result.docs.isEmpty && documents.isEmpty) {
            self.hasMorePages = false
            self.screenStatus.value = .noData
        } else {
            self.screenStatus.value = .dataLoaded
            documents.append(contentsOf: result.docs)
            self.documents.value = documents
            self.page += 1
        }
        
        // Indicate no more data
        self.hasMorePages = (result.numFound > documents.count)
    }
    
    func resetPages() {
        page = 1
        hasMorePages = true
        documents.value.removeAll()
    }
    
    // To change search criteria when back from document details or when enter new value in search bar
    func didChangeSearchCriteria(criteia: SearchCriteria?) {
        if let criteia = criteia {
            validateSearchParameters(searchCriteria: criteia)
        }
    }
    
    // Called when user enter new value in search bar, so we reset data, and back to the default search criteria only when user clear all text in search bar (Can be changed according to the requirements )
    func didChangeSearchQuery(searchBarText: String) {
        self.resetPages()
        if searchBarText.isEmpty {
            self.searchCriteria = .searchByQuery(q: "")
        }
    }
}

// Responsible for Redirection
extension DocumentsListViewModel {
    func didSelectItem(at index: Int) {
        if self.documents.value.indices.contains(index) {
            // Navigate to document detals
            self.redirection.value = .documentDetails(doucment: self.documents.value[index])
        }
    }
}
