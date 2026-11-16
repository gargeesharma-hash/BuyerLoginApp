//
//  VerticalsStoreListCVC.swift
//  Customer BBC
//
//  Created by Mayank Bimbra on 13/02/25.
//

import UIKit
import Kingfisher

class VerticalsStoreListCVC: UICollectionViewCell {
    @IBOutlet weak var verticalImage: UIImageView!
    @IBOutlet weak var verticalLbl: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var verticalSelectedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedView.backgroundColor = .clear  // Default state (not selected)
    }
        
    func configureCell(isHighlighted: Bool) {
        selectedView.backgroundColor = isHighlighted ? UIColor.themeYellow : .clear  // Highlighted color
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        verticalImage.kf.cancelDownloadTask()
        verticalImage.image = nil
    }

    
}
