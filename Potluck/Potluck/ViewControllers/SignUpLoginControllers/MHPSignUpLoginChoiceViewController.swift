//
//  MHPSignUpLoginChoiceViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/15/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

protocol HomeUserDelegate: AnyObject {
    func updateUser(mhpUser: MHPUser)
}

protocol ProfileUserDelegate: AnyObject {
    func updateUser(mhpUser: MHPUser)
}

protocol SettingsUserDelegate: AnyObject {
    func updateUser(mhpUser: MHPUser)
}

class MHPSignUpLoginChoiceViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var txtAlert: UILabel!
    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var lblPasswordValidation: UILabel!

    var mhpUser: MHPUser?
    var firUser: User?
    lazy var request: MHPRequestHandler = {
        return MHPRequestHandler()
    }()
    weak var settingsDelegate: SettingsUserDelegate?
    weak var profileDelegate: ProfileUserDelegate?
    weak var homeUserDelegate: HomeUserDelegate?

    var isPasswordValid = true


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelTappped(_:)))
        txtPassword.addTarget(self, action: #selector(textFieldDidChange(_: )), for: UIControl.Event.editingChanged)
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        handleUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
    }


    // MARK: - Action Handlers

    @IBAction func cancelTappped(_ sender: UIBarButtonItem) {
        close()
    }

    @IBAction func loginTapped(_ sender: Any) {
        if let email = validateEmail(email: txtEmail.text), let pass = validatePassword(password: txtPassword.text) {
            SVProgressHUD.show()
            request.loginUser(email: email, password: pass) { result in
                switch result {
                case .success(let user):
                    self.mhpUser = user
                    self.updateForUserState()
                case .failure(let error):
                    DispatchQueue.main.async { [unowned self] in
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                SVProgressHUD.dismiss()
            }
        }
    }

    @IBAction func signupTapped(_ sender: Any) {
        if let email = validateEmail(email: txtEmail.text), let pass = validatePassword(password: txtPassword.text), let mhpUser = self.mhpUser {
            SVProgressHUD.show()
            request.registerUser(email: email, password: pass, mhpUser: mhpUser) { result in
                switch result {
                case .success(let user):
                    self.mhpUser = user
                    self.updateForUserState()
                case .failure(let error):
                    DispatchQueue.main.async { [unowned self] in
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                SVProgressHUD.dismiss()
            }
        }
    }

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: "Password Reset", message: "Please enter your email address:", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField { textField in
                textField.placeholder = "Input your email here..."
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // handle error
                if let email = alert.textFields?.first?.text {
                    SVProgressHUD.show()
                    self.request.resetPassword(forEmail: email) { result in
                        switch result {
                        case .success:
                            print("password reset email sent")
                        case .failure (let error):
                            print("password reset email error")
                            DispatchQueue.main.async { [unowned self] in
                                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                        SVProgressHUD.dismiss()
                    }
                }
            }))

            self.present(alert, animated: true)
        }
    }

    @IBAction func alertTapped(_ sender: Any) {
        SVProgressHUD.show()
        request.verifyEmail { result in
            switch result {
            case .success:
                DispatchQueue.main.async { [unowned self] in
                    let alertController = UIAlertController(title: "Verification email sent!",
                                                            message: "Please check your email and use the enclosed link to verify your account.",
                                                            preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .failure (let error):
                DispatchQueue.main.async { [unowned self] in
                    let alertController = UIAlertController(title: "Error sending verification email:",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            SVProgressHUD.dismiss()
        }
    }

    @IBAction func facebookTapped(_ sender: Any) {
        // set up facebook login
    }

    @IBAction func googleTapped(_ sender: Any) {
        // set up google login
    }


    // MARK: - Private methods

    fileprivate func updateForUserState() {
        if let state = mhpUser?.userState {
            switch state {
            case .registered:
                viewAlert.isHidden = true
                close()
            case .verified:
                viewAlert.isHidden = true
                if let personalVC = UIStoryboard(name: "SignUpLogin", bundle: nil).instantiateViewController(withIdentifier: "PersonalInfoVC") as? MHPPersonalInfoViewController {
                    if let user = self.mhpUser {
                        personalVC.inject(user)
                    }
                    navigationController?.present(personalVC, animated: true, completion: nil)
                }
            case .unverified:
                viewAlert.isHidden = false
                txtAlert.text = "Verification email has been sent. Please use the link in the email to verify. Tap here to resend."
                btnAlert.isEnabled = true
            case .anonymous:
                viewAlert.isHidden = true
                return
            }
        }
    }

    fileprivate func close() {
        // double check after Event flows built
        guard let tabBarCon = self.presentingViewController as? UITabBarController else { return }
        if let homeVC = tabBarCon.children[0].children[0] as? MHPHomeViewController {
            homeVC.inject(self.mhpUser!)
        }

        if self.mhpUser?.userState == .registered {
            guard let tabBarIndex = (self.presentingViewController as? UITabBarController)?.selectedIndex else { return }
            switch tabBarIndex {
            case 0:
                homeUserDelegate?.updateUser(mhpUser: self.mhpUser!)
            case 1:
                return
            case 2:
                profileDelegate?.updateUser(mhpUser: self.mhpUser!)
            case 3:
                settingsDelegate?.updateUser(mhpUser: self.mhpUser!)
            default:
                return
            }
        } else {
            if let tabs = tabBarCon.viewControllers {
                if tabs.count >= 1 {
                    tabBarCon.selectedIndex = 0
                }
            }
        }

        self.dismiss(animated: true, completion: nil)
    }


    // MARK: - In-Place Validation Helpers

    fileprivate func setupAttributeColor(if isValid: Bool) -> [NSAttributedString.Key: Any] {
        if isValid {
            return [NSAttributedString.Key.foregroundColor: UIColor.blue]
        } else {
            isPasswordValid = false
            return [NSAttributedString.Key.foregroundColor: UIColor(named: "6A6A6A") as Any]
        }
    }

    fileprivate func findRange(in baseString: String, for substring: String) -> NSRange {
        if let range = baseString.localizedStandardRange(of: substring) {
            let startIndex = baseString.distance(from: baseString.startIndex, to: range.lowerBound)
            let length = substring.count
            return NSRange(location: startIndex, length: length)
        } else {
            print("Range does not exist in the base string.")
            return NSRange(location: 0, length: 0)
        }
    }


    // MARK: - Validation Methods

    fileprivate func validateEmail(email: String?) -> String? {
        guard let trimmedText = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }

        let range = NSRange(location: 0, length: NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)

        if allMatches.count == 1,
            allMatches.first?.url?.absoluteString.contains("mailto:") == true {
            return trimmedText
        } else {
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "Error", message: "Please enter a valid email address.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            return nil
        }
    }

    fileprivate func validatePassword(password: String?) -> String? {
        var errorMsg = "Password requires at least:"

        if let txt = txtPassword.text {
            if txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
                errorMsg += "\none upper case letter"
            }
            if txt.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
                errorMsg += "\none lower case letter"
            }
            if txt.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
                errorMsg += "\none number"
            }
            if txt.count < 8 {
                errorMsg += "\neight characters"
            }
        }

        if isPasswordValid {
            return password!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else {
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "Password Error", message: errorMsg, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            return nil
        }
    }

}


// MARK: - UITextFieldDelegate

extension MHPSignUpLoginChoiceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtEmail:
            txtPassword.becomeFirstResponder()
        default:
            txtPassword.resignFirstResponder()
        }
        return true
    }

    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange = true
        if textFieldToChange == txtEmail {
            let characterSetNotAllowed = CharacterSet(charactersIn: "#!$%&^* ")
            if string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) != nil {
                shouldChange = false
            }
        }
        return shouldChange
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let attrStr = NSMutableAttributedString(
            string: "Password must be at least 8 characters, and contain at least one upper case letter, one lower case letter, and one number.",
            attributes: [
                .font: UIFont(name: "Roboto", size: 11.0) ?? UIFont.systemFont(ofSize: 11.0),
                .foregroundColor: UIColor(named: "6A6A6A") as Any
            ])

        if let txt = txtPassword.text {
            isPasswordValid = true
            attrStr.addAttributes(setupAttributeColor(if: (txt.count >= 8)),
                                  range: findRange(in: attrStr.string, for: "at least 8 characters"))
            attrStr.addAttributes(setupAttributeColor(if: (txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil)),
                                  range: findRange(in: attrStr.string, for: "one upper case letter"))
            attrStr.addAttributes(setupAttributeColor(if: (txt.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil)),
                                  range: findRange(in: attrStr.string, for: "one lower case letter"))
            attrStr.addAttributes(setupAttributeColor(if: (txt.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)),
                                  range: findRange(in: attrStr.string, for: "one number"))
        } else {
            isPasswordValid = false
        }

        lblPasswordValidation.attributedText = attrStr
    }

}


// MARK: - Injectable Protocol

extension MHPSignUpLoginChoiceViewController: Injectable {
    typealias T = MHPUser

    func inject(_ user: T) {
        self.mhpUser = user
    }

    func assertDependencies() {
        assert(self.mhpUser != nil)
    }
}

// MARK: - UserHandler Protocol

extension MHPSignUpLoginChoiceViewController: UserHandler {
    func handleUser() {
        SVProgressHUD.show()
        request.getUser { result in
            switch result {
            case .success(let user):
                self.mhpUser = user
                self.assertDependencies()
                self.updateForUserState()
            case .failure(let error):
                DispatchQueue.main.async { [unowned self] in
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            SVProgressHUD.dismiss()
        }
    }
}
