//
//  LoginViewController.swift
//  BuyerLogin
//
//  Login flow copied from the Customer BBC (Dhihyperlocal consumer) app's
//  LoginSignupPopupVC: Mobile number -> OTP -> verify -> Dashboard.
//

import UIKit
import CountryPickerView
import FTIndicator

class LoginViewController: UIViewController {

    //MARK: - IBOUTLET (mobile number view)
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var btnCrossLogin: UIButton!
    @IBOutlet weak var lblWelcomeToBhaiyaa: UILabel!
    @IBOutlet weak var enterMobileNumberLbl: UILabel!
    @IBOutlet weak var lblDefaultSentOtpStatic: UILabel!
    @IBOutlet weak var imgVWFlag: UIImageView!
    @IBOutlet weak var txtCodeDialCode: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var consentLbl: UILabel!
    @IBOutlet weak var lblByUsingTerms: UILabel!

    //MARK: - IBOUTLET (OTP view)
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var btnCrossOTP: UIButton!
    @IBOutlet weak var lblOTPVerfication: UILabel!
    @IBOutlet weak var lblOtpHasBeenStatic: UILabel!
    @IBOutlet weak var lblOTPSent: UILabel!
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var txtOtpFill: OTPTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var viewOtpInvalidError: UIView!
    @IBOutlet weak var lblInvalidOTPStatic: UILabel!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var lblHavingTroubleStatic: UILabel!
    @IBOutlet weak var lblContactUsStatic: UILabel!
    @IBOutlet weak var lblWhatupNo: UILabel!
    @IBOutlet weak var viewHghtcnst: NSLayoutConstraint!
    @IBOutlet weak var viewOtpHghtCnst: NSLayoutConstraint!
    @IBOutlet weak var lblResendTopCnst: NSLayoutConstraint!

    //MARK: - IBOUTLET (signup + explore views)
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var btnCrossSignup: UIButton!
    @IBOutlet weak var lblLetsSetupYourProfileStatic: UILabel!
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblAlreadySignup: UILabel!
    @IBOutlet weak var vwExplorePopup: UIView!
    @IBOutlet weak var btnCrossExplore: UIButton!
    @IBOutlet weak var lblWelcomeToBhaiyaaExploreScreen: UILabel!
    @IBOutlet weak var lblYoureAllSetStatic: UILabel!
    @IBOutlet weak var btnExploreHomePage: UIButton!

    //MARK: - VARIABLES
    var userInfo: [String: Any] = [:]
    var callback: (() -> Void)?
    let cpvInternal = CountryPickerView()
    var code = String()
    var shortCode = String()
    private let phoneMaxLength = 10
    var countdownTimer: Timer!
    var totalTime = 30
    var termText = ""
    let term = "Resend it"
    var otpValue = String()
    var countIncreased = 0
    private var loaderContainer: UIView?
    private var loaderLayer: CAShapeLayer?
    let byContinuing = "By continuing, you agree to our \nTerms of use & Privacy Policy"
    let termsPrivacy = "Terms of use & Privacy Policy"

    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setFontFamily()
        setupOtpView()
        setupCountyField()
        updateUI()

        self.mobileNumberView.isHidden = false
        self.btnCrossLogin.isHidden = false
        self.otpView.isHidden = true
        self.btnCrossOTP.isHidden = true
        self.signupView.isHidden = true
        self.btnCrossSignup.isHidden = true
        self.txtPhoneNumber.delegate = self
        self.txtFName.delegate = self
        self.txtLName.delegate = self
        self.referralCodeTextField.delegate = self
        applyTickToNumberKeyboards(in: view)
        updatePhoneNumberUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblByContinuingTerms()
        self.viewContact.isHidden = true
        self.countIncreased = 0
    }

    func setFontFamily() {
        self.lblWelcomeToBhaiyaa.font = UIFont().SFProTextBold(size: 17)
        self.enterMobileNumberLbl.font = UIFont().SFProTextSemibold(size: 15)
        self.btnNext.titleLabel?.font = UIFont().SFProTextSemibold(size: 15)
        self.txtPhoneNumber.font = UIFont().SFProTextRegular(size: 14)
        self.referralCodeTextField.font = UIFont().SFProTextRegular(size: 14)
        self.lblOTPVerfication.font = UIFont().SFProTextSemibold(size: 15)
        self.lblOTPSent.font = UIFont().SFProTextSemibold(size: 15)
        self.lblOtpHasBeenStatic.font = UIFont().SFProTextRegular(size: 14)
        txtOtpFill.font = UIFont().SFProTextRegular(size: 14)
        self.btnSubmit.titleLabel?.font = UIFont().SFProTextSemibold(size: 15)
        self.lblHavingTroubleStatic.font = UIFont().SFProTextRegular(size: 14)
        self.lblContactUsStatic.font = UIFont().SFProTextBold(size: 14)
        self.lblWhatupNo.font = UIFont().SFProTextRegular(size: 15)
        self.lblInvalidOTPStatic.font = UIFont().SFProTextMedium(size: 14)
        self.lblLetsSetupYourProfileStatic.font = UIFont().SFProTextMedium(size: 15)
        self.lblWelcomeToBhaiyaaExploreScreen.font = UIFont().SFProTextBold(size: 17)
        self.lblYoureAllSetStatic.font = UIFont().SFProTextRegular(size: 14)
        self.btnExploreHomePage.titleLabel?.font = UIFont().SFProTextSemibold(size: 15)
        self.lblDefaultSentOtpStatic.font = UIFont().SFProTextRegular(size: 14)
        txtCodeDialCode.font = UIFont().SFProTextRegular(size: 14)
        txtFName.font = UIFont().SFProTextRegular(size: 14)
        txtLName.font = UIFont().SFProTextRegular(size: 14)
        txtEmail.font = UIFont().SFProTextRegular(size: 14)
        self.btnRegister.titleLabel?.font = UIFont().SFProTextSemibold(size: 15)
    }

    func updateUI() {
        txtPhoneNumber.attributedPlaceholder = placeholder("Enter Phone Number")
        referralCodeTextField.attributedPlaceholder = placeholder("Referral ID")
        txtFName.attributedPlaceholder = starPlaceholder("First Name *")
        txtLName.attributedPlaceholder = starPlaceholder("Last Name *")
        txtEmail.attributedPlaceholder = placeholder("Email ID (Optional)")
        txtOtpFill.textContentType = .oneTimeCode
    }

    //MARK: - SET UP COUNTRY FIELD
    func setupCountyField() {
        cpvInternal.delegate = self
        cpvInternal.dataSource = self
        let country = cpvInternal.getCountryByCode("IN")!
        show(country)
    }

    private func show(_ country: Country) {
        self.imgVWFlag.image = country.flag
        txtCodeDialCode.text = "\(country.code)  \(country.phoneCode)"
        self.code = country.phoneCode.replacingOccurrences(of: "+", with: "")
        self.shortCode = country.code
    }

    //MARK: - IBACTION (mobile number view)
    @IBAction func btnNextAction(_ sender: UIButton) {
        ValidatePhoneField()
    }

    @IBAction func openPickerAction(_ sender: UIButton) {
        cpvInternal.showCountriesList(from: self)
    }

    @IBAction func btnCrossActionLogin(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    //MARK: - IBACTION (OTP view)
    @IBAction func btnCrossActionOTP(_ sender: UIButton) {
        self.endTimer()
        self.dismiss(animated: true)
    }

    /// Back arrow / pencil: go back to the mobile number view.
    @IBAction func hideOTPAction(_ sender: UIButton) {
        self.endTimer()
        self.otpView.isHidden = true
        self.btnCrossOTP.isHidden = true
        self.mobileNumberView.isHidden = false
        self.btnCrossLogin.isHidden = false
        self.showMobileNumberVwControls(showFlag: true)
        self.viewContact.isHidden = true
        self.viewHghtcnst.constant = 220
        self.viewOtpInvalidError.isHidden = true
        self.viewOtpHghtCnst.constant = 0
        self.lblResendTopCnst.constant = 20
    }

    @IBAction func btnSubmitOTPBack(_ sender: UIButton) {
        hideOTPAction(sender)
    }

    @IBAction func btnSubmitOTP(_ sender: UIButton) {
        if self.otpValue == "" {
            FTIndicator.showToastMessage("Please enter OTP")
        } else if self.otpValue.count != 4 {
            FTIndicator.showToastMessage("Please enter valid OTP")
        } else {
            veryfyOTP()
        }
    }

    @IBAction func mobileAction(_ sender: Any) {
        let phoneNumber = (lblWhatupNo.text ?? "").filter(\.isNumber)
        if let whatsappURL = URL(string: "whatsapp://send?phone=\(phoneNumber)"),
           UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
            FTIndicator.showToastMessage("WhatsApp not installed")
        }
    }

    //MARK: - VALIDATION
    func ValidatePhoneField() {
        let phone = txtPhoneNumber.text ?? ""
        if phone.isEmpty {
            FTIndicator.showToastMessage("Please enter phone number")
        } else if phone.count != phoneMaxLength {
            FTIndicator.showToastMessage("Please enter valid phone number")
        } else {
            self.txtPhoneNumber.resignFirstResponder()
            loginAPI(countryCode: self.code, mobileNumber: phone, referralId: referralCodeTextField.text ?? "")
        }
    }

    private func updatePhoneNumberUI() {
        let isValid = (txtPhoneNumber.text ?? "").count == phoneMaxLength
        btnNext.backgroundColor = isValid ? UIColor.themeYellow : #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1)
        btnNext.isUserInteractionEnabled = isValid
    }

    func showMobileNumberVwControls(showFlag: Bool) {
        self.consentLbl.isHidden = true
        self.btnNext.isHidden = true
        if showFlag {
            self.consentLbl.isHidden = false
            self.mobileNumberView.isHidden = false
            self.btnNext.isHidden = false
        }
    }

    //MARK: - LOGIN (SEND OTP) API
    func loginAPI(countryCode: String, mobileNumber: String, referralId: String) {
        self.startCircularLoader(on: btnNext)
        APIService.shared.loginAPI(countryShortCode: self.shortCode, countryCode: countryCode,
                                   mobileNumber: mobileNumber, referralCode: referralId) { msg, status in
            self.stopCircularLoader(on: self.btnNext)
            if status == "1" {
                UserDefaults.standard.setValue(countryCode, forKey: "MobileCode")
                UserDefaults.standard.setValue(mobileNumber, forKey: "Mobile")
                self.lblResend.attributedText = self.resendCountdownText()
                self.startTimer()

                self.lblOTPSent.text = "+\(countryCode) \(mobileNumber)"
                self.mobileNumberView.isHidden = true
                self.btnCrossLogin.isHidden = true
                self.showMobileNumberVwControls(showFlag: false)
                self.otpView.isHidden = false
                self.btnCrossOTP.isHidden = false
                self.otpTextFieldView.initializeUI()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.otpTextFieldView.showKeyboard()
                }
                FTIndicator.showToastMessage(msg)
            } else {
                self.displayAlert(title: "", message: msg)
            }
        }
    }

    //MARK: - VERIFY OTP API
    func veryfyOTP() {
        self.startCircularLoader(on: btnSubmit)
        APIService.shared.verifyOTPAPI(countryCode: self.code, mobileNumber: txtPhoneNumber.text ?? "",
                                       otp: self.otpValue) { userInfo, msg, status in
            self.stopCircularLoader(on: self.btnSubmit)
            if status == "1" {
                self.endTimer()
                self.viewOtpInvalidError.isHidden = true
                self.viewOtpHghtCnst.constant = 0
                self.mobileNumberView.isHidden = true
                self.btnCrossLogin.isHidden = true
                self.otpView.isHidden = true
                self.btnCrossOTP.isHidden = true
                self.viewContact.isHidden = true
                self.viewHghtcnst.constant = 220
                guard let info = userInfo else { return }
                self.userInfo = info
                let userId = APIService.string(info["user_id"])
                let firstname = APIService.string(info["firstname"])
                if !userId.isEmpty && !firstname.isEmpty {
                    // Existing user: popup closes and the app goes to the home page
                    self.openDashboard(userInfo: info)
                } else {
                    // New user: ask for name and email
                    self.signupView.isHidden = false
                    self.btnCrossSignup.isHidden = false
                }
                FTIndicator.showToastMessage(msg)
            } else {
                let normalizedMsg = msg.lowercased().replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression)
                if normalizedMsg == "invalid otp please try again" {
                    self.viewOtpInvalidError.isHidden = false
                    self.viewOtpHghtCnst.constant = 40
                    self.lblResendTopCnst.constant = 0
                    self.viewHghtcnst.constant = self.viewContact.isHidden == false ? 280 : 240
                } else {
                    self.viewOtpInvalidError.isHidden = true
                    self.viewOtpHghtCnst.constant = 0
                    self.viewHghtcnst.constant = 220
                    self.lblResendTopCnst.constant = 20
                    FTIndicator.showToastMessage(msg)
                }
            }
        }
    }

    /// Same as the consumer app: the popup closes and the landing page refreshes.
    private func openDashboard(userInfo: [String: Any]) {
        dismiss(animated: true) {
            self.callback?()
        }
    }

    //MARK: - SIGNUP
    @IBAction func btnSubmitDetailsAction(_ sender: UIButton) {
        ValidateBasicDetailsFields()
    }

    func ValidateBasicDetailsFields() {
        let fname = (txtFName.text ?? "").trimmingCharacters(in: .whitespaces)
        let lname = (txtLName.text ?? "").trimmingCharacters(in: .whitespaces)
        let email = txtEmail.text ?? ""
        if fname.isEmpty {
            FTIndicator.showToastMessage("Please enter first name")
        } else if lname.isEmpty {
            FTIndicator.showToastMessage("Please enter last name")
        } else if !email.isEmpty && !isEmail(email) {
            FTIndicator.showToastMessage("Please enter a valid email id")
        } else {
            updateUserInfoAPI(email: email, firstname: fname, lastname: lname)
        }
    }

    private func isEmail(_ text: String) -> Bool {
        text.range(of: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", options: .regularExpression) != nil
    }

    func updateUserInfoAPI(email: String, firstname: String, lastname: String) {
        self.startCircularLoader(on: btnRegister)
        APIService.shared.updateUserInfoAPI(email: email, firstname: firstname, lastname: lastname,
                                            userID: APIService.string(userInfo["user_id"])) { info, msg, status in
            self.stopCircularLoader(on: self.btnRegister)
            if status == "1" {
                if let info { self.userInfo = info }
                // Show Explore popup
                self.vwExplorePopup.isHidden = false
                self.btnCrossExplore.isHidden = false
                self.mobileNumberView.isHidden = true
                self.btnCrossLogin.isHidden = true
                self.otpView.isHidden = true
                self.btnCrossOTP.isHidden = true
                self.signupView.isHidden = true
                self.btnCrossSignup.isHidden = true
            } else {
                FTIndicator.showToastMessage(msg)
            }
        }
    }

    /// Back arrow on the signup view: log out and return to the mobile number view.
    @IBAction func btnBackActionSinupPage(_ sender: UIButton) {
        self.endTimer()
        self.otpView.isHidden = true
        self.btnCrossOTP.isHidden = true
        self.signupView.isHidden = true
        self.btnCrossSignup.isHidden = true
        self.mobileNumberView.isHidden = false
        self.btnCrossLogin.isHidden = false
        self.txtFName.text = ""
        self.txtLName.text = ""
        self.txtEmail.text = ""
        self.showMobileNumberVwControls(showFlag: true)
        APIService.shared.logoutCurrentUser { _, _ in }
    }

    @IBAction func btnCrossActionSignu(_ sender: UIButton) {
        openDashboard(userInfo: userInfo)
    }

    @IBAction func btnCrossActionExplore(_ sender: UIButton) {
        openDashboard(userInfo: userInfo)
    }

    @IBAction func actionExploreNearShop(_ sender: UIButton) {
        openDashboard(userInfo: userInfo)
    }

    //MARK: - TIMER (Resend OTP)
    func startTimer() {
        totalTime = 30
        endTimer()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime),
                                              userInfo: nil, repeats: true)
    }

    @objc func updateTime() {
        lblResend.alpha = 1
        if totalTime != 0 {
            totalTime -= 1
            lblResend.attributedText = resendCountdownText()
        } else {
            termText = "Didn't receive a OTP? Resend it"
            lblResendOtpSet()
            endTimer()
        }
    }

    func endTimer() {
        if countdownTimer != nil {
            totalTime = 30
            countdownTimer.invalidate()
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func resendCountdownText() -> NSAttributedString {
        let attrs11: [NSAttributedString.Key: Any] = [.font: UIFont().SFProTextRegular(size: 14.0),
                                                      .foregroundColor: UIColor(hexString: "#7B7B7B")]
        let attrs22: [NSAttributedString.Key: Any] = [.font: UIFont().SFProTextBold(size: 13.0),
                                                      .foregroundColor: UIColor.themeYellow]
        let text = NSMutableAttributedString(string: "Didn't receive a OTP? ", attributes: attrs11)
        text.append(NSAttributedString(string: "Resend in \(timeFormatted(totalTime)) sec", attributes: attrs22))
        return text
    }

    func lblResendOtpSet() {
        let text = NSMutableAttributedString(string: termText, attributes: [
            .font: UIFont().SFProTextRegular(size: 14.0),
            .foregroundColor: UIColor(hexString: "#7B7B7B")
        ])
        let range = (termText as NSString).range(of: term)
        text.addAttributes([.foregroundColor: UIColor.themeYellow,
                            .font: UIFont().SFProTextBold(size: 14.0),
                            .underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
        lblResend.attributedText = text
        if lblResend.gestureRecognizers?.isEmpty ?? true {
            lblResend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTermTapped)))
        }
        lblResend.isUserInteractionEnabled = true
        lblResend.textAlignment = .center
    }

    /// Tapping "Resend it" sends the OTP again. After 2 tries the support box shows up.
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        guard countdownTimer == nil || !countdownTimer.isValid else { return }
        self.viewOtpInvalidError.isHidden = true
        self.viewOtpHghtCnst.constant = 0
        self.lblResendTopCnst.constant = 20
        self.countIncreased += 1
        if self.countIncreased > 1 {
            self.viewContact.isHidden = false
            self.viewHghtcnst.constant = 290
        }
        let phone = txtPhoneNumber.text ?? ""
        APIService.shared.loginAPI(countryShortCode: shortCode, countryCode: code,
                                   mobileNumber: phone, referralCode: referralCodeTextField.text ?? "") { msg, status in
            if status == "1" { self.startTimer() }
            FTIndicator.showToastMessage(msg)
        }
    }

    //MARK: - BUTTON LOADER (same as consumer app)
    func startCircularLoader(on button: UIButton) {
        button.layoutIfNeeded()
        button.isEnabled = false
        button.setTitle("", for: .normal)

        let containerSize: CGFloat = 32
        let container = UIView(frame: CGRect(x: (button.bounds.width - containerSize) / 2,
                                             y: (button.bounds.height - containerSize) / 2,
                                             width: containerSize, height: containerSize))
        container.backgroundColor = .clear
        button.addSubview(container)
        loaderContainer = container

        let radius: CGFloat = containerSize / 2 - 3
        let path = UIBezierPath(arcCenter: CGPoint(x: containerSize / 2, y: containerSize / 2), radius: radius,
                                startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 0.75
        container.layer.addSublayer(layer)
        loaderLayer = layer

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .infinity
        container.layer.add(rotation, forKey: "rotateLoader")
    }

    func stopCircularLoader(on button: UIButton) {
        button.isEnabled = true
        button.setTitle("Continue", for: .normal)
        loaderContainer?.layer.removeAllAnimations()
        loaderContainer?.removeFromSuperview()
        loaderContainer = nil
        loaderLayer = nil
    }

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    //MARK: - TERMS LABEL
    func lblByContinuingTerms() {
        let grey = UIColor(hexString: "#7B7B7B")
        let text = NSMutableAttributedString(string: byContinuing, attributes: [
            .font: UIFont().SFProTextRegular(size: 14.0),
            .foregroundColor: grey
        ])
        let range = (byContinuing as NSString).range(of: termsPrivacy)
        text.addAttribute(.font, value: UIFont().SFProTextBold(size: 14.0), range: range)
        lblByUsingTerms.attributedText = text
        lblByUsingTerms.textAlignment = .center
        lblByUsingTerms.isUserInteractionEnabled = true
        if lblByUsingTerms.gestureRecognizers?.isEmpty ?? true {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTappedTermsPrivacy))
            lblByUsingTerms.addGestureRecognizer(tap)
        }
    }

    @objc func handleTermTappedTermsPrivacy(gesture: UITapGestureRecognizer) {
        // TODO: open your Terms of use & Privacy Policy page here.
    }

    //MARK: - TICK BUTTON ON NUMBER KEYBOARD
    func applyTickToNumberKeyboards(in view: UIView) {
        view.subviews.forEach { subview in
            if let tf = subview as? UITextField,
               tf.keyboardType == .numberPad ||
               tf.keyboardType == .phonePad ||
               tf.keyboardType == .decimalPad {
                addTickWithoutBlur(to: tf)
            }
            applyTickToNumberKeyboards(in: subview)
        }
    }

    func addTickWithoutBlur(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.backgroundColor = .clear
        toolbar.barTintColor = .clear
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let tick = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done,
                                   target: self, action: #selector(doneTapped))
        toolbar.items = [flex, tick]
        textField.inputAccessoryView = toolbar
    }

    @objc private func doneTapped() {
        view.endEditing(true)
    }

    private func starPlaceholder(_ text: String) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: placeholder(text))
        let range = (text as NSString).range(of: "*")
        if range.location != NSNotFound {
            result.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        }
        return result
    }

    private func placeholder(_ text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [.foregroundColor: UIColor(hexString: "#BCBFC6")])
    }
}

//MARK: - OTP FIELD
extension LoginViewController: OTPFieldViewDelegate {
    func setupOtpView() {
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = UIColor(hexString: "#DFDFDF")
        self.otpTextFieldView.filledBorderColor = UIColor(hexString: "#CFD9E7")
        self.otpTextFieldView.cursorColor = UIColor.black
        self.otpTextFieldView.displayType = .underlinedBottom
        self.otpTextFieldView.fieldSize = 50
        self.otpTextFieldView.separatorSpace = 15
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }

    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        if hasEntered {
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.backgroundColor = UIColor.themeYellow
        } else {
            if !self.viewOtpInvalidError.isHidden {
                self.viewOtpInvalidError.isHidden = true
                self.viewOtpHghtCnst.constant = 0
                self.viewHghtcnst.constant = self.viewContact.isHidden == false ? 260 : 220
                self.lblResendTopCnst.constant = 20
            }
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.backgroundColor = UIColor(hexString: "#959595")
            btnSubmit.setTitle("Continue", for: .normal)
        }
        return false
    }

    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }

    func enteredOTP(otp otpString: String) {
        otpValue = otpString
        btnSubmit.isUserInteractionEnabled = true
        btnSubmit.backgroundColor = UIColor.themeYellow
        btnSubmit.setTitle("Continue", for: .normal)
    }
}

//MARK: - COUNTRY PICKER
extension LoginViewController: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        show(country)
    }
}

//MARK: - TEXTFIELD
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == txtFName || textField == txtLName {
            let updated = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
            return updated.count <= 50
        }
        guard textField == txtPhoneNumber else { return true }
        let current = (textField.text ?? "") as NSString
        let updated = current.replacingCharacters(in: range, with: string)
        return updated.count <= phoneMaxLength && updated.allSatisfy(\.isNumber)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtPhoneNumber { updatePhoneNumberUI() }
    }
}
