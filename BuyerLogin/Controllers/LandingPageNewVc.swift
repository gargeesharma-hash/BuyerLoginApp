//
//  LandingPageNewVc.swift
//  BuyerLogin
//
//  Landing page copied from the Customer BBC (Dhihyperlocal consumer) app.
//  The storyboard scene is the original one; this controller keeps the part of
//  the original logic a logged-out user sees: header, top tabs, categories.
//

import UIKit
import CoreLocation
import FTIndicator
import Kingfisher

var selectedVerticalIndex = IndexPath(row: 0, section: 0)

class LandingPageNewVc: UIViewController {

    @IBOutlet weak var lblHeaderCity: UILabel!
    @IBOutlet weak var lblNearbyHeader: UILabel!
    @IBOutlet weak var vwShadowCommunityBanner: UIView!
    @IBOutlet weak var lblCommunityHeaderDisc: UILabel!
    @IBOutlet weak var lblCommunityCategoryHeader: UILabel!
    @IBOutlet weak var lblHeaderCommunityNoData: UILabel!
    @IBOutlet weak var imgBannerCommunity: UIImageView!
    @IBOutlet weak var vwCommunityNoData: UIView!
    @IBOutlet weak var viewNoDataWalkIn: UIView!
    @IBOutlet weak var walkInHyperlocalCollectionView: UICollectionView!
    @IBOutlet weak var vwWlakInHyperlocal: UIView!
    @IBOutlet weak var addressFavoriteAndProfileView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var addressLocationLabel: UILabel!
    @IBOutlet weak var viewScanQR: UIView!
    @IBOutlet weak var viewCartInformatinWithQr: UIView!
    @IBOutlet weak var lblCartStoreName: UILabel!
    @IBOutlet weak var lblViewStoreStatic: UILabel!
    @IBOutlet weak var lblViewCartStatic: UILabel!
    @IBOutlet weak var lblCartStoreItemCount: UILabel!
    @IBOutlet weak var activeNotificationImg: UIImageView!
    @IBOutlet weak var notificationUnreadCount: UILabel!
    @IBOutlet weak var viewMembershipCard: UIView!
    @IBOutlet weak var imgMembershipCard: UIImageView!
    @IBOutlet weak var viewMembershipCardWidthCnst: NSLayoutConstraint!
    @IBOutlet weak var imgVwSearchWithCross: UIImageView!
    @IBOutlet weak var viewComingSoon: UIView!
    @IBOutlet weak var lblExpending: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnNotifications: UIButton!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnJoinNowPlan: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var imgCartArrow: UIImageView!
    @IBOutlet weak var btnViewCart: UIButton!
    @IBOutlet weak var widthArrowImg: NSLayoutConstraint!
    @IBOutlet weak var vwCartView: UIView!
    @IBOutlet weak var leadingImgArrow: NSLayoutConstraint!
    @IBOutlet weak var btnGoToCart: UIButton!
    @IBOutlet weak var topIteamCollectionVw: UICollectionView!
    @IBOutlet weak var verticalsCollectionView: UICollectionView!
    @IBOutlet weak var lblSubCategoryStatic: UILabel!
    @IBOutlet weak var subCategoryCollVw: UICollectionView!
    @IBOutlet weak var heightSubCategoryCollVw: NSLayoutConstraint! // 220
    @IBOutlet weak var lblPowerDealsStatic: UILabel!
    @IBOutlet weak var constHeightCollViewPowerDeals: NSLayoutConstraint!
    @IBOutlet weak var powerDealsCollView: UICollectionView!
    @IBOutlet weak var lblWhatsInMind: UILabel!
    @IBOutlet weak var vwVerticals: UIView!
    @IBOutlet weak var vwSubCategory: UIView!
    @IBOutlet weak var vwPowerDeal: UIView!
    @IBOutlet weak var vwWhatsInMind: UIView!
    @IBOutlet weak var whatsInMindCollVw: UICollectionView!
    @IBOutlet weak var ImgMainBg: UIImageView!
    @IBOutlet weak var storeTableVw: UITableView!
    @IBOutlet weak var vwStaticAllStore: UIView!
    @IBOutlet weak var HeightPowerDeal: NSLayoutConstraint! // 220
    @IBOutlet weak var heightwhatsInMind: NSLayoutConstraint! //212
    @IBOutlet weak var heightVerticalsMart: NSLayoutConstraint!
    @IBOutlet weak var viewNoDataAvailable: UIView!
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoDataText: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackVwAllCollections: UIStackView!
    @IBOutlet weak var viewSignIn: UIView!
    @IBOutlet weak var lblAllStoreStatic: UILabel!
    @IBOutlet weak var topStackVw: UIStackView!
    @IBOutlet weak var bottomSpacingStoreTableVw: NSLayoutConstraint!
    @IBOutlet weak var heightAllStoreVw: NSLayoutConstraint!
    @IBOutlet weak var VerticalConstraintsforAllVertical: NSLayoutConstraint!
    @IBOutlet weak var constTopNoData: NSLayoutConstraint!
    @IBOutlet weak var vwSearchTOp: UIView!

    //MARK: - VARIABLES
    var verticalsListData: [[String: Any]] = []
    var getVerticalsList: [[String: Any]] = []
    var nameIteamBgImgArray: [String] = []
    var selectVerticalName: String?
    var selectedVerticalId: String?
    var discountDealOfTheDay: DiscountStore?
    var discountNearbyStores: [DiscountStore] = []
    var discountCoupons: [CouponListItem] = []
    var allCouponsList: [CouponListItem] = []
    var category = String()
    var selectedCategoryDiscount = String()
    private let locationManager = CLLocationManager()
    private var didResolveLocation = false
    private var isLoggedIn: Bool { !APIService.shared.userId.isEmpty }

    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let rowWiseLayout = RowWisePagedLayout()
        rowWiseLayout.rows = 2
        rowWiseLayout.columns = 4
        whatsInMindCollVw.collectionViewLayout = rowWiseLayout
        whatsInMindCollVw.showsHorizontalScrollIndicator = false

        [topIteamCollectionVw, verticalsCollectionView, subCategoryCollVw, powerDealsCollView,
         whatsInMindCollVw, walkInHyperlocalCollectionView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
        }
        storeTableVw.delegate = self
        storeTableVw.dataSource = self
        storeTableVw.isScrollEnabled = false
        storeTableVw.register(UINib(nibName: HomeDiscountsListTVC.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HomeDiscountsListTVC.reuseIdentifier)
        storeTableVw.register(UINib(nibName: AllDiscountsTVC.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AllDiscountsTVC.reuseIdentifier)
        storeTableVw.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        self.callAuthTokenAPI()
        self.setupLocation()

        self.lblSubCategoryStatic.font = UIFont().SFProTextSemibold(size: 15)
        self.lblPowerDealsStatic.font = UIFont().SFProTextSemibold(size: 15)
        self.lblWhatsInMind.font = UIFont().SFProTextSemibold(size: 15)
        self.powerDealsCollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.walkInHyperlocalCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        searchTextField.delegate = self
        searchTextField.inputAccessoryView = nil
        scrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoggedIn {
            viewSignIn.isHidden = true
        } else {
            viewSignIn.isHidden = false
            if viewSignIn.gestureRecognizers?.isEmpty ?? true {
                viewSignIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSignInTapped)))
                let swipe = UISwipeGestureRecognizer(target: self, action: #selector(viewSignInTapped))
                swipe.direction = .up
                viewSignIn.addGestureRecognizer(swipe)
            }
        }
        viewScanQR.isHidden = false
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            tableViewHeightConstraint.constant = storeTableVw.contentSize.height + storeTableVw.contentInset.bottom
        }
    }

    deinit {
        storeTableVw?.removeObserver(self, forKeyPath: "contentSize")
    }

    func updateTableViewHeight() {
        storeTableVw.layoutIfNeeded()
        tableViewHeightConstraint.constant = storeTableVw.contentSize.height + storeTableVw.contentInset.bottom
        scrollView.contentInset.bottom = 50
    }

    //MARK: - DISCOUNTS
    func discountCategoryValue(for vertical: [String: Any]?) -> String {
        let raw = APIService.string(vertical?["value"])
        return raw.lowercased() == "all" ? "all" : raw
    }

    func selectedDiscountVertical() -> [String: Any]? {
        getVerticalsList.first { APIService.string($0["id"]) == self.selectedVerticalId } ?? getVerticalsList.first
    }

    func loadDiscountsForSelectedVertical() {
        let vertical = selectedDiscountVertical()
        let categoryValue = discountCategoryValue(for: vertical)
        self.selectedCategoryDiscount = categoryValue
        self.category = APIService.string(vertical?["display"])
        self.fetchDiscounts(category: categoryValue)
        self.fetchAllCoupons(page: "1", category: categoryValue)
    }

    func fetchDiscounts(category: String) {
        APIService.shared.fetchDiscounts(category: category) { [weak self] dealOfTheDay, nearbyStores, couponSection, msg, status in
            guard let self = self else { return }
            if status == "1" {
                self.discountDealOfTheDay = dealOfTheDay
                self.discountNearbyStores = nearbyStores ?? []
                self.discountCoupons = couponSection?.coupons ?? []
                if (self.discountDealOfTheDay?.storeId == nil || self.discountDealOfTheDay?.storeId == "") && self.discountNearbyStores.count == 0 && self.discountCoupons.count == 0 {
                    self.viewNoDataAvailable.isHidden = false
                    self.lblNoDataText.text = "No data found."
                    self.constTopNoData.constant = 100
                } else {
                    self.constTopNoData.constant = 0
                    self.viewNoDataAvailable.isHidden = true
                }
                self.updateTableViewHeight()
                self.storeTableVw.reloadData()
            } else {
                self.constTopNoData.constant = 60
                let lowerMsg = (msg ?? "").lowercased()
                if lowerMsg.contains("latitude") || lowerMsg.contains("longitude") {
                    self.viewNoDataAvailable.isHidden = false
                    self.lblNoDataText.text = "Please set your delivery location to see discounts near you"
                } else {
                    FTIndicator.showToastMessage(msg ?? "")
                }
            }
        }
    }

    func fetchAllCoupons(page: String = "1", category: String) {
        APIService.shared.fetchAllCoupons(page: page, category: category) { [weak self] coupons, msg, status, _, _ in
            guard let self = self else { return }
            if status == "1" {
                self.allCouponsList = coupons ?? []
                self.storeTableVw.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.storeTableVw.reloadData()
                }
                self.updateTableViewHeight()
            } else {
                let lowerMsg = (msg ?? "").lowercased()
                if !(lowerMsg.contains("latitude") || lowerMsg.contains("longitude")) {
                    FTIndicator.showToastMessage(msg ?? "")
                }
            }
        }
    }

    //MARK: - LOCATION
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    private func locationSelected(_ location: CLLocation) {
        guard !didResolveLocation else { return }
        didResolveLocation = true
        let lat = "\(location.coordinate.latitude)"
        let long = "\(location.coordinate.longitude)"
        UserDefaults.standard.set(lat, forKey: "userCurrentLat")
        UserDefaults.standard.set(long, forKey: "userCurrentLong")
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            let p = placemarks?.first
            let pincode = p?.postalCode ?? ""
            let parts = [p?.subLocality, p?.locality, p?.administrativeArea].compactMap { $0 }.filter { !$0.isEmpty }
            let fullAddress = ([pincode] + [parts.joined(separator: ", ")]).filter { !$0.isEmpty }.joined(separator: " ")
            UserDefaults.standard.set(fullAddress, forKey: "fullAddressBeforeLogin")
            UserDefaults.standard.set("yes", forKey: "isFirstSelectedLocation")
            self.addressLocationLabel.text = fullAddress
            self.addressTypeLabel.text = fullAddress.components(separatedBy: " ").first ?? ""
            self.getStatusCommunityLive(pincode: pincode, lat: lat, long: long)
        }
    }

    //MARK: - APIS
    func callAuthTokenAPI() {
        APIService.shared.authTokenAPI { success in
            if success {
                self.getAllVerticalsListAPI()
            }
        }
    }

    func getStatusCommunityLive(pincode: String, lat: String, long: String) {
        APIService.shared.getStatusCommunityLive(pincode: pincode, lat: lat, long: long) { result, _, status in
            let locationStatus = (result["locationStatus"] as? NSNumber)?.intValue ?? 0
            if status == "1" && locationStatus == 1 {
                UserDefaults.standard.set("live", forKey: "user_interaction")
                self.showComingSoonView(false)
                // Location is now known: load the selected tab again with the new lat/long
                self.selectVerticalName = nil
                self.viewNoDataAvailable.isHidden = true
                self.getAllVerticalsListAPI()
            } else {
                UserDefaults.standard.set("coming_soon", forKey: "user_interaction")
                self.showComingSoonView(true)
            }
        }
    }

    func showComingSoonView(_ show: Bool) {
        if show {
            scrollView.isHidden = false
            topStackVw.isHidden = false
            viewComingSoon.isHidden = false
            stackVwAllCollections.isHidden = true
            storeTableVw.isHidden = true
            scrollView.isScrollEnabled = false
            ImgMainBg.removeOldGradient()
            ImgMainBg.applyLinearGradientHome(colors: [UIColor(hexString: "#C1C1C1").cgColor,
                                                       UIColor(hexString: "#FDFDFD").cgColor])
        } else {
            viewComingSoon.isHidden = true
            stackVwAllCollections.isHidden = false
            storeTableVw.isHidden = false
            scrollView.isScrollEnabled = true
        }
    }

    func getAllVerticalsListAPI() {
        APIService.shared.getAllVerticalsAPI { list, _, status in
            guard status == "1" else { return }
            self.scrollView.isHidden = false
            self.topStackVw.isHidden = false
            self.nameIteamBgImgArray.removeAll()
            self.verticalsListData = list.sorted {
                (($0["sequence"] as? NSNumber)?.intValue ?? Int.max) < (($1["sequence"] as? NSNumber)?.intValue ?? Int.max)
            }
            for item in self.verticalsListData {
                let display = APIService.string(item["display"])
                let id = APIService.string(item["id"])
                switch display {
                case "Mart":
                    self.nameIteamBgImgArray.append("#36F225")
                    self.vwSubCategory.isHidden = true
                    self.heightSubCategoryCollVw.constant = 0
                    if self.selectVerticalName == nil {
                        self.selectVerticalName = display
                        self.getVerticalsApi(getSelectedcategoryType: id)
                    }
                case "Food":
                    self.nameIteamBgImgArray.append("#FFC82A")
                case "Health Services", "Health":
                    self.nameIteamBgImgArray.append("#EE9F2F")
                    if self.selectVerticalName == nil {
                        self.selectVerticalName = display == "Health" ? "health services" : display
                        self.getVerticalsApi(getSelectedcategoryType: id)
                    }
                case "Community":
                    self.nameIteamBgImgArray.append("#5825F2")
                    self.vwPowerDeal.isHidden = true
                    self.HeightPowerDeal.constant = 0
                    self.vwStaticAllStore.isHidden = true
                case "Discounts":
                    self.nameIteamBgImgArray.append("#FF7A00")
                    self.vwPowerDeal.isHidden = true
                    self.HeightPowerDeal.constant = 0
                    self.vwStaticAllStore.isHidden = true
                    if self.selectVerticalName == nil {
                        self.selectVerticalName = display
                        self.getDiscountCategoryAPI(getSelectedcategoryType: id.lowercased())
                    }
                case "Events":
                    self.nameIteamBgImgArray.append("#25CCF2")
                default:
                    break
                }
            }
            self.updateSearchPlaceholder()
            self.updateUIForVertical(display: self.selectVerticalName ?? "")
            if !self.isLoggedIn, selectedVerticalIndex.row == 0 {
                self.didTapZeroIndexTab()
            }
            self.topIteamCollectionVw.reloadData()
        }
    }

    func getVerticalsApi(getSelectedcategoryType: String) {
        APIService.shared.getNewVerticalsForStoreListingAPI(id: getSelectedcategoryType) { list, _, status in
            self.applyVerticals(list, status: status)
        }
    }

    func getDiscountCategoryAPI(getSelectedcategoryType: String) {
        APIService.shared.getDiscountVerticalsAPI(id: getSelectedcategoryType) { list, _, status in
            self.applyVerticals(list, status: status)
        }
    }

    private func applyVerticals(_ list: [[String: Any]], status: String) {
        if status == "1" {
            self.getVerticalsList = list
            self.centerCollectionViewContentIfNeeded(collectionView: self.verticalsCollectionView, items: list)
            let hasValidSelectedId = list.contains { APIService.string($0["id"]) == self.selectedVerticalId }
            if !hasValidSelectedId { self.selectedVerticalId = nil }
            if self.selectedVerticalId == nil, let first = list.first {
                self.selectedVerticalId = APIService.string(first["id"])
            }
            if self.selectVerticalName?.lowercased() == "discounts" {
                self.loadDiscountsForSelectedVertical()
            }
            self.scrollToZeroIndex()
        } else {
            self.getVerticalsList.removeAll()
        }
        self.verticalsCollectionView.reloadData()
    }

    //MARK: - UI HELPERS (same as the consumer app)
    func didTapZeroIndexTab() {
        selectedVerticalIndex = IndexPath(item: 0, section: 0)
        topIteamCollectionVw.reloadData()
        DispatchQueue.main.async {
            self.topIteamCollectionVw.layoutIfNeeded()
            guard self.topIteamCollectionVw.numberOfItems(inSection: 0) > 0 else { return }
            self.topIteamCollectionVw.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
    }

    func scrollToZeroIndex() {
        DispatchQueue.main.async {
            guard self.verticalsCollectionView.numberOfItems(inSection: 0) > 0 else { return }
            self.verticalsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        }
    }

    func centerCollectionViewContentIfNeeded(collectionView: UICollectionView, items: [[String: Any]]) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let totalCellWidth = items.reduce(CGFloat(0)) { total, item in
            total + getLayoutWidth(title: APIService.string(item["display"])) + 25
        }
        let totalSpacing = CGFloat(max(items.count - 1, 0)) * layout.minimumInteritemSpacing
        let contentWidth = totalCellWidth + totalSpacing
        let collectionWidth = collectionView.bounds.width
        if contentWidth < collectionWidth {
            let inset = (collectionWidth - contentWidth) / 2
            layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        } else {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func getLayoutWidth(title: String) -> CGFloat {
        let label: UILabel = UILabel()
        label.font = UIFont().SFProDisplayMedium(size: 13)
        label.numberOfLines = 1
        label.text = title
        label.sizeToFit()
        return label.frame.width
    }

    func normalizedVerticalKey(_ display: String?) -> String {
        let value = (display ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return value == "health services" ? "health" : value
    }

    func searchPlaceholder(forVertical display: String?) -> String {
        switch normalizedVerticalKey(display) {
        case "food": return "Search Restaurants"
        case "community": return "Search Communities"
        case "events", "event": return "Search Events"
        case "health", "health services": return "Search Healthcare Services"
        default: return "Search Products & Stores"
        }
    }

    func updateSearchPlaceholder(forVertical display: String? = nil) {
        self.searchTextField.placeholder = self.searchPlaceholder(forVertical: display ?? self.selectVerticalName)
        self.vwSearchTOp.isHidden = ["discount", "discounts"].contains(self.normalizedVerticalKey(display ?? self.selectVerticalName))
    }

    func indexOfSelectedVertical() -> Int? {
        let target = normalizedVerticalKey(self.selectVerticalName)
        guard !target.isEmpty else { return nil }
        return self.verticalsListData.firstIndex { self.normalizedVerticalKey(APIService.string($0["display"])) == target }
    }

    func updateUIForVertical(display: String) {
        switch display {
        case "Grocery", "grocery", "Mart", "mart", "Fashion", "fashion", "Beauty", "beauty", "Electronics", "electronics", "Home", "home":
            self.lblPowerDealsStatic.text = "Power deals on nearby stores"
            lblAllStoreStatic.addCharactersSpacing(spacing: 3, text: "ALL STORES")
        case "Food", "food":
            self.lblPowerDealsStatic.text = "What’s on your mind?"
            lblAllStoreStatic.addCharactersSpacing(spacing: 3, text: "ALL STORES")
        default:
            self.lblPowerDealsStatic.text = "Affordable Care, Trusted Partners"
            lblAllStoreStatic.addCharactersSpacing(spacing: 3, text: "ALL HOSPITALS")
        }
    }

    //MARK: - LOGIN POPUP
    func presentLoginPopup() {
        guard presentedViewController == nil else { return }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.callback = { [weak self] in
            self?.viewSignIn.isHidden = true
            self?.viewWillAppear(true)
        }
        present(vc, animated: true)
    }

    @objc private func viewSignInTapped() {
        presentLoginPopup()
    }

    /// Logged-out: every action opens the login popup, as in the consumer app.
    private func loginGate() {
        if !isLoggedIn { presentLoginPopup() }
    }

    //MARK: - IBACTION
    @IBAction func addressDropDownButtonAction(_ sender: Any) { loginGate() }
    @IBAction func btnBellIcon(_ sender: Any) { loginGate() }
    @IBAction func btnProfileTappedAction(_ sender: Any) { loginGate() }
    @IBAction func heartButtonAction(_ sender: Any) { loginGate() }
    @IBAction func actionMembershipCard(_ sender: Any) { loginGate() }
    @IBAction func btnCrossTappedAction(_ sender: Any) { loginGate() }
    @IBAction func scanQRAction(_ sender: Any) { loginGate() }
    @IBAction func viewCartAction(_ sender: Any) { loginGate() }
    @IBAction func viewStoreAction(_ sender: Any) { loginGate() }
    @IBAction func crossCartTappedAction(_ sender: Any) { viewCartInformatinWithQr.isHidden = true }
}

//MARK: - COLLECTION VIEWS
extension LandingPageNewVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == verticalsCollectionView { return getVerticalsList.count }
        if collectionView == topIteamCollectionVw { return verticalsListData.count }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == verticalsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerticalsStoreListCVC", for: indexPath) as! VerticalsStoreListCVC
            let item = getVerticalsList[indexPath.row]
            cell.verticalLbl.text = APIService.string(item["display"])
            cell.selectedView.isHidden = false
            let isSelected = (self.selectedVerticalId == APIService.string(item["id"]))
            cell.selectedView.backgroundColor = isSelected ? UIColor.themeYellow : .clear
            cell.verticalLbl.textColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
            cell.verticalLbl.font = isSelected ? UIFont().SFProTextSemibold(size: 12) : UIFont().SFProTextRegular(size: 12)
            let icon = APIService.string(item[isSelected ? "selected_icon" : "unselected_icon"])
            cell.verticalImage.kf.setImage(with: URL(string: icon), placeholder: UIImage(named: "ic_all_selected"))
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTabCVC", for: indexPath) as! HomeTabCVC
        let dataRow = indexPath.row
        let model = verticalsListData[dataRow]
        cell.lblIteamName.text = APIService.string(model["display"])
        cell.lblIteamName.font = UIFont().SFProTextBold(size: 12)
        if let url = URL(string: APIService.string(model["imageUrl"])) {
            cell.imgIteam.kf.setImage(with: url, placeholder: UIImage(named: "ic_house"),
                                      options: [.transition(.fade(0.25)), .cacheOriginalImage])
        } else {
            cell.imgIteam.image = UIImage(named: "ic_house")
        }
        cell.applyEnabledUI()
        cell.configureRecentVisitsCell(userInteraction: "live")
        let isSelected = (indexOfSelectedVertical() ?? selectedVerticalIndex.row) == dataRow
        if isSelected {
            var selectedHex = APIService.string(model["colour_code"])
            if selectedHex.isEmpty, dataRow < nameIteamBgImgArray.count { selectedHex = nameIteamBgImgArray[dataRow] }
            cell.applySelectedUI(colorHex: selectedHex, secondColorHex: APIService.string(model["second_colour_code"]))
            let gradientHex = selectedHex.isEmpty ? "#FDFDFD" : selectedHex
            ImgMainBg.removeOldGradient()
            ImgMainBg.applyLinearGradientHome(colors: [UIColor(hexString: gradientHex).withAlphaComponent(0.3).cgColor,
                                                       UIColor(hexString: "#FDFDFD").cgColor])
        } else {
            cell.applyUnselectedUI()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loginGate()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == verticalsCollectionView {
            let title = APIService.string(getVerticalsList[indexPath.row]["display"])
            return CGSize(width: getLayoutWidth(title: title) + 30, height: collectionView.frame.height)
        }
        return CGSize(width: 128, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == verticalsCollectionView ? 10 : 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == verticalsCollectionView ? 10 : 0
    }
}

//MARK: - TABLE VIEW
extension LandingPageNewVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectVerticalName == "Discounts" {
            // Row 0 = HomeDiscountsListTVC (Deal of day / Nearby / Coupons + ALL DISCOUNTS header)
            // Following rows = AllDiscountsTVC store cards
            return 1 + allCouponsList.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeDiscountsListTVC.reuseIdentifier, for: indexPath) as! HomeDiscountsListTVC
            cell.selectionStyle = .none
            cell.category = self.category
            cell.haveAllDiscount = self.allCouponsList.count != 0
            cell.configure(dealOfTheDay: discountDealOfTheDay,
                           nearbyStores: discountNearbyStores,
                           coupons: discountCoupons)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: AllDiscountsTVC.reuseIdentifier, for: indexPath) as! AllDiscountsTVC
        cell.selectionStyle = .none
        let couponIndex = indexPath.row - 1
        if couponIndex < allCouponsList.count {
            cell.configure(with: allCouponsList[couponIndex])
        }
        return cell
    }
}

//MARK: - SCROLL / SEARCH
extension LandingPageNewVc: UIScrollViewDelegate, UITextFieldDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        let shouldHide = scrollView.contentOffset.y > 0
        if addressFavoriteAndProfileView.isHidden != shouldHide {
            addressFavoriteAndProfileView.isHidden = shouldHide
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.addressFavoriteAndProfileView.alpha = shouldHide ? 0 : 1
            }, completion: nil)
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isLoggedIn {
            presentLoginPopup()
            return false
        }
        return true
    }
}

//MARK: - LOCATION DELEGATE
extension LandingPageNewVc: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last { locationSelected(location) }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

final class RowWisePagedLayout: UICollectionViewLayout {
    var rows = 2
    var columns = 4
    var itemSpacing: CGFloat = 10
    var lineSpacing: CGFloat = 10
    var sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentWidth: CGFloat = 0

    override func prepare() {
        super.prepare()
        cache.removeAll()
        contentWidth = 0
        guard let cv = collectionView, cv.numberOfSections > 0, cv.bounds.width > 0, cv.bounds.height > 0 else { return }

        let pageWidth = cv.bounds.width
        let count = cv.numberOfItems(inSection: 0)
        let perPage = rows * columns
        let itemWidth = (pageWidth - sectionInset.left - sectionInset.right - CGFloat(columns - 1) * itemSpacing) / CGFloat(columns)
        let itemHeight = (cv.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * lineSpacing) / CGFloat(rows)

        for item in 0..<count {
            let page = item / perPage
            let indexInPage = item % perPage
            let row = indexInPage / columns
            let column = indexInPage % columns
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            attributes.frame = CGRect(
                x: CGFloat(page) * pageWidth + sectionInset.left + CGFloat(column) * (itemWidth + itemSpacing),
                y: sectionInset.top + CGFloat(row) * (itemHeight + lineSpacing),
                width: itemWidth,
                height: itemHeight
            )
            cache.append(attributes)
        }
        contentWidth = CGFloat((count + perPage - 1) / perPage) * pageWidth
    }

    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: collectionView?.bounds.height ?? 0)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        indexPath.item < cache.count ? cache[indexPath.item] : nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        newBounds.size != collectionView?.bounds.size
    }
}

