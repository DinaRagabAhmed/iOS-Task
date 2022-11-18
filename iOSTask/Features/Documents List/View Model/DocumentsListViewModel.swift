//
//  DocumentsListViewModel.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

// MARK: - View Model Inputs
protocol DocumentsListViewModelInput {
    func didSearch(searchCriteria: SearchCriteria)
    func didLoadNextPage()
    func didSelectItem(at index: Int)
    func didChangeSearchQuery()
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
                                                                     page: self.page)) { [weak self] response in
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
                }
            }
        } else {
            self.errorsObservable.value = .networkError
            
        }
    }
    
    func didSearch(searchCriteria: SearchCriteria) {
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
    
    func setupSearchRquest(searchCriteria: SearchCriteria) {
        self.provider?.cancelAllRequests()
        self.resetPages()
        self.getDocuments(searchCriteria: searchCriteria, loading: .firstPage)
    }
    
    func didLoadNextPage() {
        print("did load next page")
        guard hasMorePages, paginationOption.value == .none else { return }
        getDocuments(searchCriteria: searchCriteria, loading: .nextPage)
    }
    
    func didSelectItem(at index: Int) {
        if self.documents.value.indices.contains(index) {
            // Navigate to document detals
            self.redirection.value = .documentDetails(doucment: self.documents.value[index])
        }
    }
    
    private func handlePagination(result: DocumentsResponse) {
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
        
        //Indicate no more data
        self.hasMorePages = (result.numFound > documents.count)
    }
    
    private func resetPages() {
        page = 1
        hasMorePages = true
        documents.value.removeAll()
    }
    
    //To change search criteria when back from document details or when enter new value in search bar
    func changeSearchCriteria(criteia: SearchCriteria?) {
        if let criteia = criteia {
            didSearch(searchCriteria: criteia)
        }
    }
    
    //Called when user enter new value in search bar, so we reset data
    func didChangeSearchQuery() {
        self.resetPages()
    }
}
