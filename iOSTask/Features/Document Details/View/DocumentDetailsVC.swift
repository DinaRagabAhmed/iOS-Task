//
//  DocumentDetailsVC.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit

class DocumentDetailsVC: BaseViewController {
    
    @IBOutlet weak var documentTableView: UITableView!
    // MARK: - Properties
    var viewModel: DocumentDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        registerCells()
        setupCellCustomization()
    }
    
    func registerCells() {
        documentTableView.register(DocumentDataCell.nib,
                                   forCellReuseIdentifier: DocumentDataCell.identifier)
        documentTableView.register(ISBNCell.nib,
                                   forCellReuseIdentifier: ISBNCell.identifier)
    }
    
    func setupCellCustomization() {
        documentTableView.estimatedRowHeight = 100
        documentTableView.rowHeight = UITableView.automaticDimension
        documentTableView.tableFooterView = UIView()
        documentTableView.separatorStyle = .none
        documentTableView.dataSource = self
        documentTableView.delegate = self
        documentTableView.allowsSelection = false
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.viewModel.dismissView()
    }
}

// MARK: - Responsible for handling Table View
extension DocumentDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.viewModel.getISBNsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentDataCell.identifier,
                                                     for: indexPath) as? DocumentDataCell
            cell?.setData(document: self.viewModel.document.value ?? nil, delegate: self)
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ISBNCell.identifier,
                                                     for: indexPath) as? ISBNCell
            cell?.setData(isbn: self.viewModel.getISBN(index: indexPath.row-1))
            return cell ?? UITableViewCell()
        }
    }
}

extension DocumentDetailsVC: SearchCriteriaProtocol {
    func didSelectSearchCriteria(searchBy: SearchCriteria) {
        self.viewModel.selectSearchCriteria(criteria: searchBy)
    }
}

protocol SearchCriteriaProtocol: AnyObject {
    func didSelectSearchCriteria(searchBy: SearchCriteria)
}
