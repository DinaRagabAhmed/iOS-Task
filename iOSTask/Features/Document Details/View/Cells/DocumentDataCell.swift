//
//  DocumentDataCell.swift
//  iOSTask
//
//  Created by Dina Ragab on 16/11/2022.
//

import UIKit

class DocumentDataCell: UITableViewCell {

    @IBOutlet weak var documentAuthorLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var documentTitleLabel: UILabel!
    
    weak var delegate: SearchCriteriaProtocol?
    var document = Document()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        setGestures()
    }
    
    func setUI() {
        self.isbnLabel.text = "ISBNs".localized()
    }
    
    func setGestures() {
        let documentTitleTap = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorName))
        documentAuthorLabel.addGestureRecognizer(documentTitleTap)
        
        let authorNameTap = UITapGestureRecognizer(target: self, action: #selector(didSelectDocumentTitle))
        documentTitleLabel.addGestureRecognizer(authorNameTap)
    }
    
    func setData(document: Document?, delegate: SearchCriteriaProtocol) {
        self.delegate = delegate
        self.document = document ?? Document()
        self.isbnLabel.isHidden = document?.isbn?.isEmpty ?? true
        
        self.documentTitleLabel.text = document?.title ?? ""
        if let authorsNames =  document?.authorName, !authorsNames.isEmpty {
            self.documentAuthorLabel.isHidden = false
            self.documentAuthorLabel.text = authorsNames.joined(separator: " ,")
        } else {
            self.documentAuthorLabel.text = ""
            self.documentAuthorLabel.isHidden = true
        }
    }

    @objc func didSelectAuthorName(sender: UITapGestureRecognizer) {
        didSelectNewSearchCriteria(criteria: .searchByAuthorName(authorName: self.document.authorName?.first ?? ""))
    }
    
    @objc func didSelectDocumentTitle(sender: UITapGestureRecognizer) {
        didSelectNewSearchCriteria(criteria: .searchByDocumentTitle(documentTitle: self.document.title ?? ""))
    }
    
    func didSelectNewSearchCriteria(criteria: SearchCriteria) {
        if let delegate = delegate {
            delegate.didSelectSearchCriteria(searchBy: criteria)
        }
    }
}
