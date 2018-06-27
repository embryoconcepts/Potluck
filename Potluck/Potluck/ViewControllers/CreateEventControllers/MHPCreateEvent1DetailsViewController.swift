//
//  MHPCreateEvent1DetailsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 3/11/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

class MHPCreateEvent1DetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtLocationName: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnLocationSearch: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    var mhpUser: MHPUser?
    var event: MHPEvent?
    
    let txtViewPlaceholderText = "Describe your event - let guests know if there is a theme, or a special occasion."
    var address: String?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        assertDependencies()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func pickerChanged(_ sender: Any) {
        let selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        event?.eventDate = formatter.string(from: selectedDate)
        
    }
    
    @IBAction func locationSearchTapped(_ sender: Any) {
        if let locationSearchVC = UIStoryboard(name: "CreateEvent", bundle: nil).instantiateViewController(withIdentifier: "locationSearchVC") as? MHPLocationSearchViewController {
            locationSearchVC.delegate = self
            self.present(locationSearchVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTappped(_ sender: UIButton) {
        cancel()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        next()
    }
    
    
    // MARK: - Keyboard Handlers
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Private methods
    
    fileprivate func setupView() {
        // delegates
        scrollView.delegate = self
        txtName.delegate = self
        txtDescription.delegate = self
        txtLocationName.delegate = self
        
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        // set up scrollview + keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // style description text view
        txtDescription.text = txtViewPlaceholderText
        txtDescription.textColor = .lightGray
        txtDescription.layer.borderColor = UIColor(hexString: "ebebeb").cgColor
        txtDescription.layer.borderWidth = 1.0
        txtDescription.layer.cornerRadius = 5
        
        datePicker.minimumDate = Date()
    }
    
    fileprivate func resetView() {
        // TODO: improve clearing event handling
        self.event = nil
        self.mhpUser = nil
        self.txtName.text = ""
        self.txtDescription.text = self.txtViewPlaceholderText
        self.txtDescription.textColor = .lightGray
        self.datePicker.date = Date()
        self.txtLocationName.text = ""
        self.btnLocationSearch.titleLabel?.text = "Tap for Address Search"
    }
    
    fileprivate func cancel() {
        let alert = UIAlertController(title: "Cancel Event",
                                      message: "Are you sure you want to cancel creating a Potluck? All event data will be lost.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { action in
            self.resetView()
            
            // return to Home
            self.tabBarController?.tabBar.isHidden = false
            if let tabs = self.tabBarController?.viewControllers {
                if tabs.count > 0 {
                    self.tabBarController?.selectedIndex = 0
                }
            }
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    fileprivate func next() {
        if validate() {
            if  let user = mhpUser,
                let event = event,
                let createEvent2 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent2InvitesViewController") as? MHPCreateEvent2InvitesViewController {
                createEvent2.inject(user)
                createEvent2.inject(event)
                navigationController?.pushViewController(createEvent2, animated: true)
            }
        }
    }
    
    fileprivate func validate() -> Bool {
        var errorMsg = "Required fields:"
        var isValid = true
        
        if txtName.text == "" {
            errorMsg += "\nname"
            isValid = false
        }
        
        if txtDescription.text == "" || txtDescription.text == txtViewPlaceholderText {
            errorMsg += "\ndescription"
            isValid = false
        }
        
        let nextHour = Date().add(component: .hour, value: 1)
        if datePicker.date < nextHour! {
            errorMsg += "\nvalid date"
            isValid = false
        }
        
        if txtLocationName.text == "" {
            errorMsg += "\nlocation"
            isValid = false
        }
        
        if !isValid {
            let alertController = UIAlertController(title: "Missing Details", message: errorMsg, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return isValid
    }
    
}


// MARK: - UITextViewDelegate

extension MHPCreateEvent1DetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = txtViewPlaceholderText
            textView.textColor = UIColor.lightGray
        } else {
            event?.eventDescription = textView.text
        }
    }
    
}


// MARK: - UITextFieldDelegate

extension MHPCreateEvent1DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtName.resignFirstResponder()
            txtLocationName.becomeFirstResponder()
        case txtLocationName:
            txtLocationName.resignFirstResponder()
            txtName.becomeFirstResponder()
        default:
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtName:
            event?.eventName = textField.text
        case txtLocationName:
            event?.eventLocation = textField.text
        default:
            return
        }
    }
}


// MARK: - LocationSearchSelectionDelegate

extension MHPCreateEvent1DetailsViewController: LocationSearchSelectionDelegate {
    func didSelectLocation(controller: MHPLocationSearchViewController, address: String) {
        btnLocationSearch.setTitle("", for: .normal)
        lblAddress.text = address
        event?.eventAddress = address
    }
}

// MARK: - UserInjectable Protocol

extension MHPCreateEvent1DetailsViewController: Injectable {
    typealias T = MHPUser
    typealias U = MHPEvent
    
    func inject(_ user: T) {
        self.mhpUser = user
    }
    
    func inject(_ event: U) {
        self.event = event
    }
    
    func assertDependencies() {
        assert(self.mhpUser != nil)
        
        if event == nil {
            event = MHPEvent()
            event?.eventHost = mhpUser
        }
    }
}
