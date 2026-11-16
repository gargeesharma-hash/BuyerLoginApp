//
//  HomeTabCVC.swift
//  Customer BBC
//
//  Created by Akshay Kumar on 22/12/25.
//

import UIKit
import Kingfisher

/// A view whose backing layer IS a CAGradientLayer, so the gradient always fills
/// the view's bounds automatically — no manual frame management or layout timing
/// dependency (which caused the gradient to render wrong on first login/logout).
final class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
}

class HomeTabCVC: UICollectionViewCell {

    @IBOutlet weak var imgIteam: UIImageView!
    @IBOutlet weak var lblIteamName: UILabel!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var backgroundVw: UIView!

    // Gradient used for the selected state when two colour codes are provided.
    private let bgGradientView = GradientView()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        vwBg.layer.cornerRadius = 16
        vwBg.layer.borderWidth = 1.5
        vwBg.layer.borderColor = UIColor(hexString: "#CACACA").cgColor
        vwBg.backgroundColor = .clear
        vwBg.layer.masksToBounds = true

        // Add the gradient view once. Auto-resizing keeps it filling vwBg at all times,
        // so it renders correctly no matter when the cell is laid out.
        bgGradientView.isUserInteractionEnabled = false
        bgGradientView.isHidden = true
        bgGradientView.frame = vwBg.bounds
        bgGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgGradientView.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        bgGradientView.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        vwBg.insertSubview(bgGradientView, at: 0)

        lblIteamName.textColor = .darkGray
        imgIteam.contentMode = .scaleAspectFit
        imgIteam.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imgIteam.kf.cancelDownloadTask()
        imgIteam.image = UIImage(named: "placeholder")

        lblIteamName.text = nil
        lblIteamName.textColor = .darkGray

        bgGradientView.isHidden = true
        vwBg.backgroundColor = .clear
        vwBg.layer.borderWidth = 1.5
        vwBg.layer.borderColor = UIColor(hexString: "#CACACA").cgColor

        imgIteam.alpha = 1.0
        backgroundVw.alpha = 1.0
    }

    // MARK: - UI States

    /// Selected state. If `secondColorHex` also has a value, `vwBg` shows a top-to-bottom
    /// gradient (colorHex → secondColorHex). Otherwise it shows the single `colorHex`.
    func applySelectedUI(colorHex: String, secondColorHex: String? = nil) {
        vwBg.layer.borderWidth = 0
        lblIteamName.textColor = .white
        imgIteam.alpha = 1.0
        backgroundVw.alpha = 1.0

        let hasFirst = !colorHex.isEmpty
        let hasSecond = !(secondColorHex ?? "").isEmpty

        if hasFirst && hasSecond {
            // Two colours → gradient from top (colorHex) to bottom (secondColorHex).
            vwBg.backgroundColor = .clear
            bgGradientView.gradientLayer.colors = [
                UIColor(hexString: colorHex).cgColor,
                UIColor(hexString: secondColorHex ?? "").cgColor
            ]
            bgGradientView.isHidden = false
        } else {
            // Single colour → solid background, no gradient.
            bgGradientView.isHidden = true
            vwBg.backgroundColor = UIColor(hexString: colorHex)
        }
    }

    func applyUnselectedUI() {
        bgGradientView.isHidden = true
        vwBg.backgroundColor = UIColor(hexString: "#FFFFFF").withAlphaComponent(0.2)
        vwBg.layer.borderWidth = 1.5
        vwBg.layer.borderColor = UIColor(hexString: "#CACACA").cgColor
        lblIteamName.textColor = .darkGray
        imgIteam.alpha = 1.0
        backgroundVw.alpha = 1.0
    }
    
    func applyDisabledUI() {
        imgIteam.alpha = 0.4
        backgroundVw.alpha = 0.4
        isUserInteractionEnabled = false
    }
    func applyEnabledUI() {
        // Re-enable interaction at cell level
        isUserInteractionEnabled = true
    }
    
    // MARK: - Recent Visits
    func configureRecentVisitsCell(userInteraction: String?) {
        guard let interaction = userInteraction?.lowercased() else { return }
        
        if interaction == "live" || interaction.isEmpty {
            imgIteam.alpha = 1.0
            backgroundVw.alpha = 1.0
            applyEnabledUI()
        } else {
            applyDisabledUI()
        }
    }
}
