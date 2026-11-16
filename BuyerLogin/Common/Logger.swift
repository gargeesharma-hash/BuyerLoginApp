//
//  Logger.swift
//  BuyerLogin
//
//  Same console format as the Customer BBC app's Logger.
//

import Foundation

/// This `Logger` Class has `isLoggingEnabled` variale  Indicating whether we need to print Logs or not. On live always enter this boolean variable as false
class Logger {

    /// `Instance` of Logger Class
    static let instance = Logger()
    private init() {}

    /// This `isLoggingEnabled` variable is Indicating whether we need to print Logs or not. On live always enter this boolean variable as false
    #if DEBUG
    var isLoggingEnabled: Bool = true
    #else
    var isLoggingEnabled: Bool = false
    #endif

    /// Method To Print Api Request
    func printApiRequest(url: String, method: String, parameters: [String: Any], headers: [String: String]) {
        if self.isLoggingEnabled {
            print(#function, "\n", "-------------- API (\(url)) REQUEST PARAMS ------------------")
            print("URL :-", url)
            print("METHOD TYPE :-", method)
            // Convert parameters to JSON format for better readability
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("PARAMETERS :-")
                print(jsonString)
            } else {
                print("PARAMETERS :-", parameters)
            }
            print("HEADERS :-\n\(headers.map { "\($0.key): \($0.value)" }.sorted().joined(separator: "\n"))")
            print("----------------------------------------------------", "\n")
        }
    }

    /// Method To Print Api Response
    func printApiResponse(url: String, response: Data?) {
        if self.isLoggingEnabled {
            if let jsonData: Data = response {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            print(#function, "\n", "-------------- API (\(url)) SUCCESS RESPONSE ------------------")
                            print(jsonString)
                            print("----------------------------------------------------", "\n")
                        }
                    }
                } catch {
                    print(#function, #file, #line, "API URL :- (\(url))", error.localizedDescription)
                }
            }
        }
    }
}
