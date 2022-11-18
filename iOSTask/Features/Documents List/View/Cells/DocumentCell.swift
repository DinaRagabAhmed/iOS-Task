//
//  DocumentCell.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var documentAuthorLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var documentTitleLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        self.authorLabel.text = "authors".localized()
    }
    
    func setData(document: Document?) {
        self.documentTitleLabel.text = document?.title ?? ""
        if let authorsNames =  document?.authorName, !authorsNames.isEmpty {
            self.documentAuthorLabel.text = authorsNames.joined(separator: " ,")
        } else {
            self.documentAuthorLabel.text = "missing_info".localized()
        }
    }
}
