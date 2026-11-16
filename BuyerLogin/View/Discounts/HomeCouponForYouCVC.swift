//
//  HomeCouponForYouCVC.swift
//  Customer BBC
//
//  Created by Shrikant Ghagare on 28/05/26.
//

import UIKit
import FTIndicator

class HomeCouponForYouCVC: UICollectionViewCell {

    //MARK: Cell Outlets
    @IBOutlet weak var copuonBgVw: UIView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblOffPrice: UILabel!
    @IBOutlet weak var lblMinOfferValue: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnRedeemNow: UIButton!
    
    
    //MARK: Properties
    private let dashedBorderLayer = CAShapeLayer()
    private let shapeMaskLayer = CAShapeLayer()
    private let couponCornerRadius: CGFloat = 15
    /// Radius of the two semicircular cuts on the left/right edges.
    private let notchRadius: CGFloat = 12

    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCouponShape()
    }

    //MARK: Coupon Shape (rounded corners + side notches + dashed border)
    private func setupCouponShape() {
        // Cream/peach fill (orange at 20% alpha) that the old `ic_dashborderLine`
        // image used to provide. The mask below clips it to the notched outline.
        copuonBgVw.backgroundColor = UIColor(red: 0.9412, green: 0.6275, blue: 0.1765, alpha: 0.2)

        // Mask that punches the two side notches out of the background view.
        copuonBgVw.layer.mask = shapeMaskLayer

        // Dashed border that follows the same notched outline.
        dashedBorderLayer.fillColor = UIColor.clear.cgColor
        dashedBorderLayer.strokeColor = UIColor(red: 0.91, green: 0.58, blue: 0.23, alpha: 1.0).cgColor
        dashedBorderLayer.lineWidth = 1.5
        dashedBorderLayer.lineDashPattern = [4, 4]
        dashedBorderLayer.lineJoin = .round
        copuonBgVw.layer.addSublayer(dashedBorderLayer)
    }

    /// Builds the coupon outline: a rounded rect with a semicircular cut on the
    /// left and right edges at the vertical center.
    private func couponPath(in rect: CGRect) -> UIBezierPath {
        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY
        let cr = couponCornerRadius
        let nr = notchRadius
        let midY = rect.midY

        let path = UIBezierPath()
        // Top edge
        path.move(to: CGPoint(x: minX + cr, y: minY))
        path.addLine(to: CGPoint(x: maxX - cr, y: minY))
        // Top-right corner
        path.addArc(withCenter: CGPoint(x: maxX - cr, y: minY + cr), radius: cr,
                    startAngle: -.pi / 2, endAngle: 0, clockwise: true)
        // Right edge down to notch
        path.addLine(to: CGPoint(x: maxX, y: midY - nr))
        // Right notch (cuts inward)
        path.addArc(withCenter: CGPoint(x: maxX, y: midY), radius: nr,
                    startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: false)
        // Right edge down to bottom-right corner
        path.addLine(to: CGPoint(x: maxX, y: maxY - cr))
        // Bottom-right corner
        path.addArc(withCenter: CGPoint(x: maxX - cr, y: maxY - cr), radius: cr,
                    startAngle: 0, endAngle: .pi / 2, clockwise: true)
        // Bottom edge
        path.addLine(to: CGPoint(x: minX + cr, y: maxY))
        // Bottom-left corner
        path.addArc(withCenter: CGPoint(x: minX + cr, y: maxY - cr), radius: cr,
                    startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        // Left edge up to notch
        path.addLine(to: CGPoint(x: minX, y: midY + nr))
        // Left notch (cuts inward)
        path.addArc(withCenter: CGPoint(x: minX, y: midY), radius: nr,
                    startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: false)
        // Left edge up to top-left corner
        path.addLine(to: CGPoint(x: minX, y: minY + cr))
        // Top-left corner
        path.addArc(withCenter: CGPoint(x: minX + cr, y: minY + cr), radius: cr,
                    startAngle: .pi, endAngle: -.pi / 2, clockwise: true)
        path.close()
        return path
    }

    /// Same outline as `couponPath` but the two notches are left as gaps (no stroke),
    /// so the dashed border is not drawn around the leading/trailing cuts.
    private func couponBorderPath(in rect: CGRect) -> UIBezierPath {
        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY
        let cr = couponCornerRadius
        let nr = notchRadius
        let midY = rect.midY

        let path = UIBezierPath()
        // Top edge
        path.move(to: CGPoint(x: minX + cr, y: minY))
        path.addLine(to: CGPoint(x: maxX - cr, y: minY))
        // Top-right corner
        path.addArc(withCenter: CGPoint(x: maxX - cr, y: minY + cr), radius: cr,
                    startAngle: -.pi / 2, endAngle: 0, clockwise: true)
        // Right edge down to the top of the notch
        path.addLine(to: CGPoint(x: maxX, y: midY - nr))
        // Skip the right notch (gap — no border in the cut)
        path.move(to: CGPoint(x: maxX, y: midY + nr))
        // Right edge down to bottom-right corner
        path.addLine(to: CGPoint(x: maxX, y: maxY - cr))
        // Bottom-right corner
        path.addArc(withCenter: CGPoint(x: maxX - cr, y: maxY - cr), radius: cr,
                    startAngle: 0, endAngle: .pi / 2, clockwise: true)
        // Bottom edge
        path.addLine(to: CGPoint(x: minX + cr, y: maxY))
        // Bottom-left corner
        path.addArc(withCenter: CGPoint(x: minX + cr, y: maxY - cr), radius: cr,
                    startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        // Left edge up to the bottom of the notch
        path.addLine(to: CGPoint(x: minX, y: midY + nr))
        // Skip the left notch (gap — no border in the cut)
        path.move(to: CGPoint(x: minX, y: midY - nr))
        // Left edge up to top-left corner
        path.addLine(to: CGPoint(x: minX, y: minY + cr))
        // Top-left corner
        path.addArc(withCenter: CGPoint(x: minX + cr, y: minY + cr), radius: cr,
                    startAngle: .pi, endAngle: -.pi / 2, clockwise: true)
        // No close() — the perimeter already meets at the top-left start point,
        // and closing would draw a stroke across the last notch gap.
        return path
    }

    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = copuonBgVw.bounds
        // Mask uses the full-bounds outline so the notches become transparent.
        shapeMaskLayer.frame = bounds
        shapeMaskLayer.path = couponPath(in: bounds).cgPath
        // Border uses the gapped outline so it is not drawn around the notches.
        // Inset by half the line width so the stroke isn't clipped by the mask.
        let inset = dashedBorderLayer.lineWidth / 2
        dashedBorderLayer.frame = bounds
        dashedBorderLayer.path = couponBorderPath(in: bounds.insetBy(dx: inset, dy: inset)).cgPath
    }

    //MARK: Properties (callback)
    /// Called when the Redeem button is tapped. The owning cell handles navigation.
    var onTapRedeem: ((CouponListItem) -> Void)?
    private var coupon: CouponListItem?

    //MARK: Configure
    func configure(with coupon: CouponListItem) {
        self.coupon = coupon
        lblStoreName.text = coupon.couponTitle
        lblOffPrice.text = coupon.discountText
        lblMinOfferValue.text = coupon.minOrderText
        lblCode.text = coupon.couponCode
        btnRedeemNow.setTitle(coupon.buttonText, for: .normal)
    }


    @IBAction func btnRedeemNowTappedAction(_ sender: UIButton) {
        guard let coupon = coupon else { return }
        // Copy the coupon code to the clipboard and show a toast.
        if let code = coupon.couponCode, !code.isEmpty {
            UIPasteboard.general.string = code
            FTIndicator.showToastMessage("Copied to clipboard.")
        }
        onTapRedeem?(coupon)
    }
}
