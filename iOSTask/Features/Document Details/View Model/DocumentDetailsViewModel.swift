//
//  DocumentDetailsViewModel.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

protocol DocumentDetailsViewModelInput {
    func getISBNsCount() -> Int
    func getISBN(index: Int) -> String
    func dismissView()
    func selectSearchCriteria(criteria: SearchCriteria)
}

protocol DocumentDetailsViewModelOutput {
    var document: Observable<Document?> { get }
    var screenResult: Observable<DocumentDetailsResult?> { get }
}

protocol DocumentDetailsViewModelProtocol: DocumentDetailsViewModelInput, DocumentDetailsViewModelOutput {}

class DocumentDetailsViewModel: BaseViewModel, DocumentDetailsViewModelProtocol {
    
    let document: Observable<Document?> = Observable(nil)
    let screenResult: Observable<DocumentDetailsResult?> = Observable(nil)

    init(provider: ProviderProtocol?, document: Document) {
        self.document.value = document
        super.init(provider: provider)
    }

}

extension DocumentDetailsViewModel {
   
    func getISBNsCount() -> Int {
        let document = self.document.value ?? Document()
        if (document.isbn?.count ?? 0) >= 5 {
            return 5
        } else {
            return document.isbn?.count ?? 0
        }
    }
    
    func getISBN(index: Int) -> String {
        let document = self.document.value ?? Document()
        return document.isbn?[index] ?? ""
    }
    
    func dismissView() {
        self.screenResult.value = .back
    }
    
    // Back to previous screen with the new search criteria
    func selectSearchCriteria(criteria: SearchCriteria) {
        self.screenResult.value = .search(criteria: criteria)
    }
}
