//
//  HomeDiscountsListTVC.swift
//  Customer BBC
//
//  Created by Shrikant Ghagare on 27/05/26.
//

import UIKit

class HomeDiscountsListTVC: UITableViewCell {
    
    @IBOutlet weak var lblNearByStores: UILabel!
    @IBOutlet weak var viewAllStores: UIView!
    @IBOutlet weak var viewCouponForYou: UIView!
    @IBOutlet weak var viewNearByStore: UIView!
    @IBOutlet weak var viewDealOfTheDay: UIView!
    @IBOutlet weak var lblAllDiscounts: UILabel!
    //MARK: Outlets
    @IBOutlet weak var CollVwDealOfDay: UICollectionView!
    @IBOutlet weak var collVwNearByStore: UICollectionView!
    @IBOutlet weak var collVwCouponForYou: UICollectionView!

    //MARK: Data
    private var dealOfTheDay: DiscountStore?
    private var nearbyStores: [DiscountStore] = []
    private var coupons: [CouponListItem] = []
    var onDealOfferTapped: ((DiscountStore) -> Void)?
    var category : String?
    var onStoreSelected: ((String) -> Void)?
    var haveAllDiscount = false
    /// CleverTap Native Display card shown at the 2nd position of "Nearby stores".
    func configure(dealOfTheDay: DiscountStore?, nearbyStores: [DiscountStore], coupons: [CouponListItem]) {
        self.dealOfTheDay = dealOfTheDay
        self.nearbyStores = nearbyStores
        self.coupons = coupons
        if self.dealOfTheDay?.storeId == nil || self.dealOfTheDay?.storeId == ""{
            self.viewDealOfTheDay.isHidden = true
        }else{
            self.viewDealOfTheDay.isHidden = false
        }
        if self.coupons.count == 0{
            self.viewCouponForYou.isHidden = true
        }else{
            self.viewCouponForYou.isHidden = false
        }
        if self.nearbyStores.count == 0{
            self.viewNearByStore.isHidden = true
        }else{
            self.viewNearByStore.isHidden = false
        }
        if self.haveAllDiscount{
            self.viewAllStores.isHidden = false
        }else{
            self.viewAllStores.isHidden = true
        }
        self.lblAllDiscounts.addCharactersSpacing(spacing: 1, text: "ALL DISCOUNTS")
        self.lblNearByStores.addCharactersSpacing(spacing: 1, text: "NEARBY STORES")
        self.lblAllDiscounts.font = UIFont().SFProTextMedium(size: 12)
        self.lblNearByStores.font = UIFont().SFProTextMedium(size: 12)
        CollVwDealOfDay.reloadData()
        collVwNearByStore.reloadData()
        collVwCouponForYou.reloadData()
    }

    /// Shows the Native Display card in "Nearby stores" (call after `configure`).
    override func awakeFromNib() {
        super.awakeFromNib()
        CollVwDealOfDay.register(UINib(nibName: "HomeDealOfDayCVC", bundle: nil), forCellWithReuseIdentifier: "HomeDealOfDayCVC")
        collVwNearByStore.register(UINib(nibName: "NearbyHomeDiscountListCVC", bundle: nil), forCellWithReuseIdentifier: "NearbyHomeDiscountListCVC")
        collVwCouponForYou.register(UINib(nibName: "HomeCouponForYouCVC", bundle: nil), forCellWithReuseIdentifier: "HomeCouponForYouCVC")
        
        CollVwDealOfDay.delegate = self
        CollVwDealOfDay.dataSource = self
    
        collVwNearByStore.delegate = self
        collVwNearByStore.dataSource = self
        
        collVwCouponForYou.delegate = self
        collVwCouponForYou.dataSource = self
        // Initialization code
    }

    //MARK: setSelected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    //MARK: layoutSubviews
    private var lastLaidOutWidth: CGFloat = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        // The inner collection views are sized off their own bounds.width in
        // sizeForItemAt. On first layout that width is still the xib design width,
        // so recompute the layouts once the cell takes the real screen width.
        if lastLaidOutWidth != bounds.width {
            lastLaidOutWidth = bounds.width
            CollVwDealOfDay.collectionViewLayout.invalidateLayout()
            collVwNearByStore.collectionViewLayout.invalidateLayout()
            collVwCouponForYou.collectionViewLayout.invalidateLayout()
        }
    }
}


extension HomeDiscountsListTVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CollVwDealOfDay {
            return dealOfTheDay == nil ? 0 : 1
        } else if collectionView == collVwNearByStore {
            return nearbyStores.count
        } else {
            return coupons.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == CollVwDealOfDay {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDealOfDayCVC", for: indexPath) as! HomeDealOfDayCVC
                if let deal = dealOfTheDay {
                    cell.configure(with: deal)
                }
                cell.onTapOffer = { [weak self] store in
                    self?.onDealOfferTapped?(store)
                }
                return cell
            } else if collectionView == collVwNearByStore {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyHomeDiscountListCVC", for: indexPath) as! NearbyHomeDiscountListCVC
                let storeIndex = indexPath.item
                guard storeIndex < nearbyStores.count else { return cell }
                cell.configure(with: nearbyStores[storeIndex])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCouponForYouCVC", for: indexPath) as! HomeCouponForYouCVC
                cell.configure(with: coupons[indexPath.item])
                cell.onTapRedeem = { [weak self] coupon in
                    guard let id = coupon.storeId, !id.isEmpty else { return }
                    self?.onStoreSelected?(id)
                }
                return cell
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storeId: String?
            if collectionView == CollVwDealOfDay {
                storeId = dealOfTheDay?.storeId
            } else if collectionView == collVwNearByStore {
                let storeIndex = indexPath.item
                guard storeIndex < nearbyStores.count else { return }
                storeId = nearbyStores[storeIndex].storeId
            } else {
                return
            }
            guard let id = storeId, !id.isEmpty else { return }
            onStoreSelected?(id)
        }


}

// MARK: - Collection View Flow Layout (cell sizing)
extension HomeDiscountsListTVC: UICollectionViewDelegateFlowLayout {

    private var sideInset: CGFloat { 16 }
    private var itemSpacing: CGFloat { 10 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let availableWidth = collectionView.bounds.width - (sideInset * 2)

        if collectionView == CollVwDealOfDay {
            // Deal of the day → one full-width banner card
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == collVwNearByStore {
            // Nearby stores → ~2.2 cards visible at a time
          
            return CGSize(width: (collectionView.frame.width / 2.7) - 2, height: collectionView.frame.height)
        } else {
            // Coupons for you → one full card + a half peek of the next
            let width = (availableWidth - itemSpacing) / 1.5
            return CGSize(width: width, height: 150)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView != CollVwDealOfDay {
            return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != CollVwDealOfDay {
            return itemSpacing
        }else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != CollVwDealOfDay {
            return itemSpacing
        }else{
            return 0
        }
    }
}
