//
//  PreviewCollectionViewCell.swift
//  NNSCANNER
//
//  Created by Nhat on 20/04/2023.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteButton.cornerVN()
    }

}
