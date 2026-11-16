//
//  NearbyHomeDiscountListCVC.swift
//  Customer BBC
//
//  Created by Shrikant Ghagare on 28/05/26.
//

import UIKit
import Kingfisher

class NearbyHomeDiscountListCVC: UICollectionViewCell {

    //MARK: Outlets
    @IBOutlet weak var vwOffer: UIView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblOfferName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var vwshadow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: Configure
    func configure(with store: DiscountStore) {
        lblStoreName.text = store.storeName
        lblDiscount.text = store.discountText
        lblOfferName.text = shortLocation(from: store.storeAddress)
        lblDistance.text = store.distance

        if let urlStr = store.storeImage, let url = URL(string: urlStr) {
            imgStore.kf.setImage(with: url, placeholder: UIImage(named: "ic_store_placeholder"))
        } else {
            imgStore.image = UIImage(named: "ic_store_placeholder")
        }

        setupCornerRadius()

        DispatchQueue.main.async {
            self.applyBlackGradient(to: self.vwshadow, fade: true)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
    }
    private func setupCornerRadius() {
      
        vwOffer.layer.cornerRadius = self.vwOffer.frame.height / 2
        vwOffer.layer.masksToBounds = true
        vwOffer.clipsToBounds = true
    }

    //MARK: Helpers
    private func shortLocation(from address: String?) -> String? {
        guard let address = address,
              !address.trimmingCharacters(in: .whitespaces).isEmpty else {
            return address
        }

        let parts = address
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        if parts.count > 1 {
            return parts[1]
        } else if parts.count == 1 {
            return parts[0]
        } else {
            return address
        }
    }

}
