//
//  DocumentsListVC.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit

class DocumentsListVC: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var noDataView: NoDataView!
    @IBOutlet weak var documentsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var viewModel: DocumentsListViewModel!
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupBinding()
        setupTableView()
    }
    
    func setUI() {
        setupSearchBar()
        setStrings()
    }
    
    func setupSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.updateHeightAndCornerRadious(height: Constants.searchBarHeight.rawValue,
                                                    radius: Constants.searchBarRadious.rawValue)
    }
    
    func setStrings() {
        searchButton.setTitle("search".localized(), for: .normal)
        searchButton.setTitle("search".localized(), for: .selected)
    }
    
    private func setupBinding() {
        super.setupBindings(baseViewModel: viewModel)
        viewModel.documents.observe(on: self) { [weak self] _ in self?.updateDocuments()}
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery(query: $0)}
        viewModel.screenStatus.observe(on: self) { [weak self] in self?.handleScreenStatus(screenStatus: $0)}
        viewModel.paginationOption.observe(on: self) { [weak self] in self?.updateLoading($0)}
    }
    
    func setupTableView() {
        registerCells()
        setupCellCustomization()
    }
    
    func registerCells() {
        documentsTableView.register(DocumentCell.nib,
                                    forCellReuseIdentifier: DocumentCell.identifier)
    }
    
    func setupCellCustomization() {
        documentsTableView.estimatedRowHeight = Constants.tableViewRowEstimate.rawValue
        documentsTableView.rowHeight = UITableView.automaticDimension
        documentsTableView.tableFooterView = UIView()
        documentsTableView.separatorStyle = .none
        documentsTableView.dataSource = self
        documentsTableView.delegate = self
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        search()
    }
}

// MARK: - Responsible for handling outputs from View Model
extension DocumentsListVC {
    func updateDocuments() {
        DispatchQueue.main.async { [weak self] in
            self?.documentsTableView.reloadData()
        }
    }
    
    func updateSearchQuery(query: String) {
        self.searchBar.text = query
    }
    
    func handleScreenStatus(screenStatus: ScreenStatus?) {
        DispatchQueue.main.async { [weak self] in
            if let screenStatus = screenStatus {
                //Hide no data while loading screen or render data
                self?.noDataView.isHidden = !(screenStatus == .noData)
            }
        }
    }
    
    func updateLoading(_ loading: PaginationOptions?) {
        DispatchQueue.main.async { [weak self] in
            if let loading = loading {
                switch loading {
                case .nextPage:
                    self?.nextPageLoadingSpinner?.removeFromSuperview()
                    self?.nextPageLoadingSpinner = self?.makeActivityIndicator(size: .init(width: self?.view.frame.width ?? 0, height: 44))
                    self?.documentsTableView.tableFooterView = self?.nextPageLoadingSpinner
                case .firstPage:
                    self?.documentsTableView.tableFooterView = UIView()
                }
            } else {
                self?.documentsTableView.tableFooterView = UIView()
            }
        }
    }
}

// MARK: - Responsible for handling Table View
extension DocumentsListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.documents.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.identifier,
                                                 for: indexPath) as? DocumentCell
        cell?.setData(document: self.viewModel.documents.value[indexPath.row])
        
        if indexPath.row == viewModel.documents.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

extension DocumentsListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    func search() {
        guard let searchText = searchBar.text else { return }
        self.view.endEditing(true)
        // It will save search criteria (author name, document title, query) and change only text
        // Back to query only when user remove all text in search bar
        viewModel.didSubmitSearch(searchBarText: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Hide no data when user changes text
        self.noDataView.isHidden = true
        // Remove all data when user changes text in search bar
        self.viewModel.didChangeSearchQuery(searchBarText: searchText)
    }
}

private enum Constants: CGFloat {
    case searchBarHeight = 50.0
    case searchBarRadious = 15.0
    case tableViewRowEstimate = 100.0
}
