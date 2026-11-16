//
//  HomeDealOfDayCVC.swift
//  Customer BBC
//
//  Created by Shrikant Ghagare on 27/05/26.
//

import UIKit
import Kingfisher

class HomeDealOfDayCVC: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var imgDealStore: UIImageView!
    @IBOutlet weak var vwDealOfDay: UIView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblStoreDistance: UILabel!
    @IBOutlet weak var lbldiscountOff: UILabel!
    @IBOutlet weak var vwTotalOffer: UIView!
    @IBOutlet weak var lblOfferCount: UILabel!
    @IBOutlet weak var vwShadow: UIView!
    @IBOutlet weak var btnTapOfferLabel: UIButton!
    
    //MARK: Properties
    var onTapOffer: ((DiscountStore) -> Void)?
    private var store: DiscountStore?
    
    
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        btnTapOfferLabel.addTarget(self, action: #selector(offerButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Actions
    @objc private func offerButtonTapped() {
        guard let store = store else { return }
        onTapOffer?(store)
    }
    
    //MARK: Configure
    func configure(with store: DiscountStore) {
        self.store = store
        self.vwDealOfDay.layer.cornerRadius = self.vwDealOfDay.frame.height / 2
        self.vwDealOfDay.layer.masksToBounds = true
        self.vwTotalOffer.layer.cornerRadius = self.vwTotalOffer.frame.height / 2
        self.vwTotalOffer.layer.masksToBounds = true
        lblStoreName.text = store.storeName
        lblStoreDistance.text = store.distance
        lbldiscountOff.text = store.discountText
        lblOfferCount.text = "\(store.offerCount ?? "") offers"
        vwTotalOffer.isHidden = store.offerCount == "0" || store.offerCount == "" || store.offerCount == nil ? true : false
        
        if let urlStr = store.storeImage, let url = URL(string: urlStr) {
            imgDealStore.kf.setImage(with: url, placeholder: UIImage(named: "ic_store_placeholder"))
        } else {
            imgDealStore.image = UIImage(named: "ic_store_placeholder")
        }
        
        DispatchQueue.main.async {
            self.applyBlackGradient(to: self.vwShadow, fade: true)
        }
    }
    
}
