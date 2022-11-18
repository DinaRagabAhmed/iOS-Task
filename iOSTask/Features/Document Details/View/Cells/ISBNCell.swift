//
//  ISBNCell.swift
//  iOSTask
//
//  Created by Dina Ragab on 16/11/2022.
//

import UIKit
import SDWebImage

class ISBNCell: UITableViewCell {
    
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var isbnImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(isbn: String) {
        self.isbnLabel.text = isbn

        let url = URL(string: "\(Environment.imagesURL)\(isbn)-M.jpg?default=false")
        if let url = url {
            isbnImageView.sd_setImage(with: url,
                                      placeholderImage: UIImage(named: "placeholder"))
        } else {
            isbnImageView.image = UIImage(named: "placeholder")
        }
    }
    
}
