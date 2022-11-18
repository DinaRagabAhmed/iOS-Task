//
//  DocumentsListCoordinator.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

class DocumentListCoordinator: BaseCoordinator {
    
    private let router: Routing
    
    init(router: Routing) {
        self.router = router
    }
    
    override func start() {
        let viewController =  DocumentsListVC()
        let viewModel = DocumentsListViewModel(provider: DataSource.provideNetworkDataSource())
        viewController.viewModel = viewModel
        
        subscribeToRedirections(viewModel: viewModel)
        router.push(viewController, isAnimated: true, onNavigateBack: isCompleted)
    }
    
    func subscribeToRedirections(viewModel: DocumentsListViewModel) {
        
        viewModel.redirection.observe(on: self) { [weak self] (redirection) in
            guard let self = self else { return }
            if let redirection = redirection {
                switch redirection {
                case .documentDetails(let document):
                    print("documentDetails")
                    self.redirectToDocumentDetails(document: document, viewModel: viewModel)
                }
            }
        }
    }
}

// MARK: Navigation and redirection
extension DocumentListCoordinator {
    
    func redirectToDocumentDetails(document: Document, viewModel: DocumentsListViewModel) {
        let documentDetailsCoordinator = DocumentDetailsCoordinator(router: router,
                                                                    document: document)
        self.add(coordinator: documentDetailsCoordinator)
        
        documentDetailsCoordinator.isCompleted = { [weak self, weak documentDetailsCoordinator] in
            // To Remove documentDetailsCoordinator when screen is poped
            guard let coordinator = documentDetailsCoordinator else {
                return
            }
            self?.remove(coordinator: coordinator)
        }
        
        // Observe if user click on document name or author name to render documents list with the new search criteria
        documentDetailsCoordinator.searchCriteria.observe(on: documentDetailsCoordinator){[weak viewModel] newCriteria in
            viewModel?.didChangeSearchCriteria(criteia: newCriteria)
        }
        
        documentDetailsCoordinator.start()
    }
}


enum DocumentListRedirectionTypes {
    case documentDetails(doucment: Document)
}
