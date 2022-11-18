//
//  DocumentDetailsCoordinator.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

protocol DocumentDetailsCoordinatorOutput {
    var searchCriteria: Observable<SearchCriteria?> { get }
}

class DocumentDetailsCoordinator: BaseCoordinator, DocumentDetailsCoordinatorOutput {
    
    private let router: Routing
    private let document: Document
    
    let searchCriteria: Observable<SearchCriteria?> = Observable(nil)

    init(router: Routing, document: Document) {
        self.router = router
        self.document = document
    }
    
    override func start() {
        let viewController =  DocumentDetailsVC()
        let viewModel = DocumentDetailsViewModel(provider: DataSource.provideNetworkDataSource(),
                                                 document: document)
        viewController.viewModel = viewModel
        subscribeToScreenResult(viewModel: viewModel)
        router.push(viewController, isAnimated: true, onNavigateBack: isCompleted)
    }
    
    func subscribeToScreenResult(viewModel: DocumentDetailsViewModel) {

        viewModel.screenResult.observe(on: self) { [weak self] (redirection) in
            guard let self = self else { return }
            if let redirection = redirection {
                switch redirection {
                case .search(let criteria):
                    self.searchCriteria.value = criteria
                    self.router.pop(true)
                case .back:
                    self.router.pop(true)
                }
            }
            
        }
    }
}

enum DocumentDetailsResult {
    case search(criteria: SearchCriteria)
    case back
}
