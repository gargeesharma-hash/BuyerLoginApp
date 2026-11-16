//
//  Extensions.swift
//  BuyerLogin
//
//  Same helpers the Customer BBC app uses for this screen.
//

import UIKit

//MARK: - SHADOW VIEW (copied from the consumer app)
extension UIView {

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue

            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 10
            }
        }
    }

    func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1, height: 1),
                   shadowOpacity: Float = 0.5,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

extension UIView {
    @IBInspectable var cornerRadiuss: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { layer.borderColor.map { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get { layer.shadowColor.map { UIColor(cgColor: $0) } }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)
        self.init(red: CGFloat((value >> 16) & 0xFF) / 255,
                  green: CGFloat((value >> 8) & 0xFF) / 255,
                  blue: CGFloat(value & 0xFF) / 255,
                  alpha: 1)
    }

    /// Same name the consumer app uses, e.g. UIColor(hex: "#959595")
    convenience init(hex: String) {
        self.init(hexString: hex)
    }

    static var themeYellow: UIColor {
        return UIColor(hexString: "#383838")
    }
}

internal struct SFProTextFontNameConstants {
    static let Bold = "SFProText-Bold"
    static let Medium = "SFProText-Medium"
    static let Regular = "SFProText-Regular"
    static let Semibold = "SFProText-Semibold"
}

extension UIFont {
    func SFProTextBold(size: CGFloat) -> UIFont {
        UIFont(name: SFProTextFontNameConstants.Bold, size: size) ?? .boldSystemFont(ofSize: size)
    }
    func SFProTextSemibold(size: CGFloat) -> UIFont {
        UIFont(name: SFProTextFontNameConstants.Semibold, size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
    func SFProTextMedium(size: CGFloat) -> UIFont {
        UIFont(name: SFProTextFontNameConstants.Medium, size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    func SFProTextRegular(size: CGFloat) -> UIFont {
        UIFont(name: SFProTextFontNameConstants.Regular, size: size) ?? .systemFont(ofSize: size)
    }
}

extension UIFont {
    func SFProDisplayMedium(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    func SFProDisplayBold(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
}

extension UILabel {
    func addCharactersSpacing(spacing: CGFloat, text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, max(text.count - 1, 0)))
        self.attributedText = attributedString
    }
}

extension UIView {
    func applyLinearGradientHome(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "homeGradient"
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            colors.first ?? UIColor.clear.cgColor,
            (UIColor(cgColor: colors.last ?? UIColor.clear.cgColor).withAlphaComponent(0.1)).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func removeOldGradient() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}

extension NSObject {
    /// It returns the name of Class from where it is called in String " " format
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView {
    func applyBlackGradient(to view: UIView, fade: Bool = false) {
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        view.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = fade
        ? [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(1.0).cgColor]
        : [UIColor.black.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func applyLinearGradientLeftRight(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            colors.first ?? UIColor.clear.cgColor,
            (UIColor(cgColor: colors.last ?? UIColor.clear.cgColor).withAlphaComponent(0.1)).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
