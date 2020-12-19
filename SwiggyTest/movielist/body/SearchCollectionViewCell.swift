//
//  SearchCollectionViewCell.swift
//  SwiggyTest
//
//  Created by Manas1 Mishra on 28/10/20.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(name: String, id: String)  {
        self.idLabel.text = id
        self.nameLabel.text = name
    }
}
