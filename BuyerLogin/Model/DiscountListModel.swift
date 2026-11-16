//
//  DiscountListModel.swift
//  BuyerLogin
//
//  Copied from the Customer BBC app.
//

import Foundation

struct OfferData: Codable {
    let offerType: String?
    let offeredValue: String?
    let offerId: String?
    let minValue: String?
    let endValidity: String?
    let offeredValueCap: String?
    let skipQrCode: String?
    let offerName: String?
    let couponCode : String?

    enum CodingKeys: String, CodingKey {
        case offerType = "OFFER_TYPE"
        case offeredValue = "OFFERED_VALUE"
        case offerId = "offer_id"
        case minValue = "MIN_VALUE"
        case endValidity = "END_VALIDITY"
        case offeredValueCap = "OFFERED_VALUE_CAP"
        case skipQrCode = "SKIP_QR_CODE"
        case offerName = "OFFER_NAME"
        case couponCode = "COUPAN_CODE"
    }
}

struct DiscountStore: Codable {
    let redirectId: String?
    let redirectType: String?
    let storeId: String?
    let storeName: String?
    let storeAddress: String?
    let storeImage: String?
    let categoryId: String?
    let categoryName: String?
    let categoryImage: String?
    let offerCount: String?
    let discountText: String?
    let deliveryTime: String?
    let extraOfferText: String?
    let distance: String?
    let rating: String?
    let bannerColor: String?
    let offerName: String?
    let offerId: String?
    let offerData: OfferData?
   

    enum CodingKeys: String, CodingKey {
        case redirectId = "redirect_id"
        case redirectType = "redirect_type"
        case storeId = "store_id"
        case storeName = "store_name"
        case storeAddress = "store_address"
        case storeImage = "store_image"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case categoryImage = "category_image"
        case offerCount = "offer_count"
        case discountText = "discount_text"
        case deliveryTime = "delivery_time"
        case extraOfferText = "extra_offer_text"
        case distance
        case rating
        case bannerColor = "banner_color"
        case offerName = "offer_name"
        case offerId = "offer_id"
        case offerData = "offerData"
       
    }
}

struct CouponSection: Codable {
    let title: String?
    let subtitle: String?
    let coupons: [CouponListItem]?
}

struct CouponListItem: Codable {
    let couponTitle: String?
    let couponCode: String?
    let minOrderText: String?
    let isRedeemed: String?
    let buttonText: String?
    let discountText: String?
    let couponId: String?
    let storeId: String?
    // Extra store fields (present in the fetchAllCoupons list, used by AllDiscountsTVC)
    let storeName: String?
    let storeAddress: String?
    let storeImage: String?
    let offerCount: String?
    let distance: String?
    let deliveryTime: String?
    let categoryId: String?
    let categoryName: String?
    let categoryImage: String?
    let offerData: OfferData?

    enum CodingKeys: String, CodingKey {
        case couponTitle = "coupon_title"
        case couponCode = "coupon_code"
        case minOrderText = "min_order_text"
        case isRedeemed = "is_redeemed"
        case buttonText = "button_text"
        case discountText = "discount_text"
        case couponId = "coupon_id"
        case storeId = "store_id"
        case storeName = "store_name"
        case storeAddress = "store_address"
        case storeImage = "store_image"
        case offerCount = "offer_count"
        case distance
        case deliveryTime = "delivery_time"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case categoryImage = "category_image"
        case offerData = "orffrData"
    }
}
