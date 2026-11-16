//
//  APIService.swift
//  BuyerLogin
//
//  Same login APIs the Customer BBC app calls:
//    auth/auth_token  -> anonymous device token
//    auth/sendOtp     -> sends the OTP SMS
//    auth/verifyOtp   -> checks the OTP and returns the user
//
//  The server address and key are read from ServerConfig.plist,
//  which is kept out of git (see .gitignore).
//

import UIKit

struct APIResponse {
    let status: String
    let msg: String
    let result: [String: Any]
}

final class APIService {

    static let shared = APIService()

    private let session = URLSession(configuration: .default)
    private(set) var accessToken = ""
    private var accessKey = ""
    private var authToken = ""
    private(set) var userId = ""

    //MARK: - CONFIG
    private lazy var config: [String: String] = {
        guard let url = Bundle.main.url(forResource: "ServerConfig", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String] else {
            assertionFailure("ServerConfig.plist is missing. Copy ServerConfig.example.plist and fill it in.")
            return [:]
        }
        return dict
    }()

    private var baseURL: String { (config["BaseURL"] ?? "") + "/api/v1/auth/" }
    private var outhKey: String { config["OuthKey"] ?? "" }

    var deviceId: String {
        let key = "persistentDeviceId"
        if let saved = UserDefaults.standard.string(forKey: key), !saved.isEmpty { return saved }
        let id = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        UserDefaults.standard.set(id, forKey: key)
        return id
    }

    private var headers: [String: String] {
        var h = [
            "outhKey": outhKey,
            "access_key": accessKey,
            "auth_token": authToken,
            "fcm_token": "",
            "store_id": "",
            "app_type": "ios",
            "device_id": deviceId
        ]
        if !accessToken.isEmpty { h["authorization"] = "Bearer \(accessToken)" }
        if !userId.isEmpty { h["uid"] = userId }
        return h
    }

    //MARK: - AUTH TOKEN
    func authTokenAPI(completion: @escaping (Bool) -> Void) {
        post("auth_token", params: [:]) { response in
            let token = response?.result["token"] as? String ?? ""
            if !token.isEmpty { self.accessToken = token }
            completion(response?.status == "1" && !token.isEmpty)
        }
    }

    //MARK: - SEND OTP
    func loginAPI(countryShortCode: String, countryCode: String, mobileNumber: String,
                  referralCode: String, completion: @escaping (String, String) -> Void) {
        let send = {
            let params: [String: String] = [
                "country_code": countryCode,
                "mobile_number": mobileNumber,
                "countryShortCode": countryShortCode,
                "referralId": referralCode,
                "device_type": "ios",
                "device_id": self.deviceId,
                "contact_reason": "",
                "form_ts": "null",
                "form_nonce": "null",
                "form_ts_sig": "null"
            ]
            self.post("sendOtp", params: params) { response in
                completion(response?.msg ?? "Something went wrong. Please try again.",
                           response?.status ?? "0")
            }
        }
        if accessToken.isEmpty {
            authTokenAPI { _ in send() }
        } else {
            send()
        }
    }

    //MARK: - VERIFY OTP
    func verifyOTPAPI(countryCode: String, mobileNumber: String, otp: String,
                      completion: @escaping ([String: Any]?, String, String) -> Void) {
        getPublicIP { ip in
            let params: [String: String] = [
                "country_code": countryCode,
                "mobile_number": mobileNumber,
                "OTP": otp,
                "device_token": self.deviceId,
                "add_from": "ios",
                "device": UIDevice.current.model,
                "fcm_token": "",
                "ip_address": ip,
                "device_id": self.deviceId
            ]
            self.post("verifyOtp", params: params) { response in
                let userInfo = response?.result["userinfo"] as? [String: Any]
                if response?.status == "1", let info = userInfo {
                    // Same as TokenManager.saveTokens in the consumer app
                    self.userId = Self.string(info["user_id"])
                    self.accessKey = Self.string(info["access_key"])
                    self.authToken = Self.string(info["auth_token"])
                    let token = Self.string(info["access_token"])
                    if !token.isEmpty { self.accessToken = token }
                }
                completion(userInfo,
                           response?.msg ?? "Something went wrong. Please try again.",
                           response?.status ?? "0")
            }
        }
    }

    //MARK: - UPDATE USER INFO (signup)
    func updateUserInfoAPI(email: String, firstname: String, lastname: String, userID: String,
                           completion: @escaping ([String: Any]?, String, String) -> Void) {
        let params = ["user_id": userID, "email": email, "firstname": firstname, "lastname": lastname]
        post("updateUserInfo", params: params) { response in
            completion(response?.result["userinfo"] as? [String: Any],
                       response?.msg ?? "Something went wrong. Please try again.",
                       response?.status ?? "0")
        }
    }

    //MARK: - LOGOUT
    func logoutCurrentUser(completion: @escaping (String, String) -> Void) {
        let params = ["User_id": userId, "fcm_token": ""]
        post("logout", params: params, method: "PUT") { response in
            self.userId = ""; self.accessKey = ""; self.authToken = ""; self.accessToken = ""
            completion(response?.msg ?? "", response?.status ?? "0")
        }
    }

    static func string(_ value: Any?) -> String {
        if let s = value as? String { return s }
        if let n = value as? NSNumber { return n.stringValue }
        return ""
    }

    //MARK: - LANDING PAGE
    private var baseURLV18: String { (config["BaseURLV18"] ?? "") + "/v18/" }
    private var sequenceURL: String { (config["BaseURL"] ?? "") + "/api/v1/sequence/" }

    func getStatusCommunityLive(pincode: String, lat: String, long: String,
                                completion: @escaping ([String: Any], String, String) -> Void) {
        get(baseURLV18 + "checkLiveCommunity", query: ["pin_code": pincode, "lat": lat, "long": long]) { r in
            completion(r?.result ?? [:], r?.msg ?? "", r?.status ?? "0")
        }
    }

    func getAllVerticalsAPI(completion: @escaping ([[String: Any]], String, String) -> Void) {
        get(sequenceURL + "getHomeSections", query: ["category_type": ""]) { r in
            completion(r?.result["verticalsListing"] as? [[String: Any]] ?? [], r?.msg ?? "", r?.status ?? "0")
        }
    }

    func getNewVerticalsForStoreListingAPI(id: String, completion: @escaping ([[String: Any]], String, String) -> Void) {
        get(sequenceURL + "getSubCategories", query: ["id": id]) { r in
            completion(r?.result["verticalsListing"] as? [[String: Any]] ?? [], r?.msg ?? "", r?.status ?? "0")
        }
    }

    func getDiscountVerticalsAPI(id: String, completion: @escaping ([[String: Any]], String, String) -> Void) {
        get(sequenceURL + "getDiscountCategories", query: ["id": id]) { r in
            completion(r?.result["verticalsListing"] as? [[String: Any]] ?? [], r?.msg ?? "", r?.status ?? "0")
        }
    }

    private func decode<T: Decodable>(_ type: T.Type, _ value: Any?) -> T? {
        guard let value, JSONSerialization.isValidJSONObject(value),
              let data = try? JSONSerialization.data(withJSONObject: value) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private func discountParams(category: String, page: String) -> [String: String] {
        ["lat": UserDefaults.standard.string(forKey: "userCurrentLat") ?? "",
         "long": UserDefaults.standard.string(forKey: "userCurrentLong") ?? "",
         "category": category, "page": page, "user_id": userId]
    }

    func fetchDiscounts(page: String = "1", category: String = "all",
                        completion: @escaping (DiscountStore?, [DiscountStore]?, CouponSection?, String?, String?) -> Void) {
        post("fetchDiscounts", params: discountParams(category: category, page: page), base: baseURLV18) { r in
            completion(self.decode(DiscountStore.self, r?.result["dealOfTheDay"]),
                       self.decode([DiscountStore].self, r?.result["nearbyStores"]),
                       self.decode(CouponSection.self, r?.result["couponSection"]),
                       r?.msg, r?.status ?? "0")
        }
    }

    func fetchAllCoupons(page: String = "1", category: String = "All",
                         completion: @escaping ([CouponListItem]?, String?, String?, Int?, Int?) -> Void) {
        post("fetchAllCoupons", params: discountParams(category: category, page: page), base: baseURLV18) { r in
            completion(self.decode([CouponListItem].self, r?.result["coupons"]), r?.msg, r?.status ?? "0",
                       (r?.result["totalpage"] as? NSNumber)?.intValue, (r?.result["totalPageCount"] as? NSNumber)?.intValue)
        }
    }

    private func get(_ urlString: String, query: [String: String], completion: @escaping (APIResponse?) -> Void) {
        // The anonymous token must exist before any other call (the consumer app fetches it first too).
        if accessToken.isEmpty {
            authTokenAPI { success in
                if success {
                    self.get(urlString, query: query, completion: completion)
                } else {
                    completion(nil)
                }
            }
            return
        }
        var components = URLComponents(string: urlString)
        components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        Logger.instance.printApiRequest(url: urlString, method: "GET", parameters: query, headers: headers)
        session.dataTask(with: request) { data, _, _ in
            Logger.instance.printApiResponse(url: urlString, response: data)
            var result: APIResponse?
            if let data, let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
                let resultDict = (json["Result"] as? [String: Any]) ?? (json["result"] as? [String: Any]) ?? [:]
                result = APIResponse(status: "\(json["status"] ?? "0")", msg: json["msg"] as? String ?? "", result: resultDict)
            }
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }

    //MARK: - HELPERS
    private func getPublicIP(completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.ipify.org") else { return completion("") }
        session.dataTask(with: url) { data, _, _ in
            completion(data.flatMap { String(data: $0, encoding: .utf8) } ?? "")
        }.resume()
    }

    /// Form-encoded POST, same as the consumer app (URLEncoding.httpBody).
    private func post(_ path: String, params: [String: String], method: String = "POST", base: String? = nil,
                      completion: @escaping (APIResponse?) -> Void) {
        guard let url = URL(string: (base ?? baseURL) + path) else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = formEncode(params).data(using: .utf8)

        Logger.instance.printApiRequest(url: url.absoluteString, method: method, parameters: params, headers: headers)

        session.dataTask(with: request) { data, _, error in
            Logger.instance.printApiResponse(url: url.absoluteString, response: data)
            var result: APIResponse?
            if let data,
               let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
                // Server sends "Result" (capital R); the consumer app reads "result" as a fallback.
                let resultDict = (json["Result"] as? [String: Any]) ?? (json["result"] as? [String: Any]) ?? [:]
                result = APIResponse(status: "\(json["status"] ?? "0")",
                                     msg: json["msg"] as? String ?? "",
                                     result: resultDict)
            } else if let error {
                print("API URL :- (\(url.absoluteString))", error.localizedDescription)
            }
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }

    private func formEncode(_ params: [String: String]) -> String {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._~")
        return params.map { key, value in
            let k = key.addingPercentEncoding(withAllowedCharacters: allowed) ?? key
            let v = value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
            return "\(k)=\(v)"
        }.joined(separator: "&")
    }
}
