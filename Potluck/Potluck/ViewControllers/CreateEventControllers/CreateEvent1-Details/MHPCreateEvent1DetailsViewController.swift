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
    @IBOutlet weak var btnClearAddress: UIButton!
    
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
        
        setupView()
        assertDependencies()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func pickerChanged(_ sender: Any) {
        let selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        event?.date = formatter.string(from: selectedDate)
        
    }
    
    @IBAction func locationSearchTapped(_ sender: Any) {
        if let locationSearchVC = UIStoryboard(name: "CreateEvent", bundle: nil).instantiateViewController(withIdentifier: "locationSearchVC") as? MHPLocationSearchViewController {
            locationSearchVC.delegate = self
            self.present(locationSearchVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func clearAddressTapped(_ sender: Any) {
        lblAddress.text = ""
        event?.address = nil
        btnClearAddress.isEnabled = false
        btnClearAddress.isHidden = true
    }
    
    @IBAction func cancelTappped(_ sender: UIButton) {
        cancel()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        next()
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // set values
        txtName.text = event?.title ?? ""
        if let desc = event?.description {
            txtDescription.text = desc
            txtDescription.textColor = .black
        } else {
            txtDescription.text = txtViewPlaceholderText
            txtDescription.textColor = .lightGray
        }
        datePicker.minimumDate = Date()
        txtLocationName.text = event?.location ?? ""
        if let address = event?.address {
            lblAddress.text = address
            btnClearAddress.isEnabled = true
            btnClearAddress.isHidden = false
        } else {
            lblAddress.text = ""
            btnClearAddress.isEnabled = false
            btnClearAddress.isHidden = true
        }
        
        
        // style description text view
        txtDescription.layer.borderColor = UIColor(hexString: "ebebeb").cgColor
        txtDescription.layer.borderWidth = 1.0
        txtDescription.layer.cornerRadius = 5
        
        setupKeyboardDoneButton()
        setupKeyboardDismissOnTap()
        scrollView.keyboardDismissMode = .interactive
    }
    
    fileprivate func resetView() {
        self.event = nil
        self.mhpUser = nil
        self.txtName.text = ""
        self.txtDescription.text = self.txtViewPlaceholderText
        self.txtDescription.textColor = .lightGray
        self.datePicker.date = Date()
        self.txtLocationName.text = ""
    }
    
    fileprivate func cancel() {
        self.presentCancelAlert(view: self)
    }
    
    fileprivate func next() {
        if validate() {
            event?.title = txtName.text
            event?.description = txtDescription.text
            event?.location = txtLocationName.text
            event?.address = lblAddress.text
            if  let event = event,
                let createEvent2 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent2InvitesViewController") as? MHPCreateEvent2InvitesViewController {
                createEvent2.dataDelegate = self
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
        
        let nextMin = Date().add(component: .minute, value: 1)
        if datePicker.date < nextMin! {
            errorMsg += "\nvalid date"
            isValid = false
        }
        
        if txtLocationName.text == "" && lblAddress.text == "" {
            errorMsg += "\nlocation or address"
            isValid = false
        }
        
        if !isValid {
            DispatchQueue.main.async { [unowned self] in
                let alertController = UIAlertController(title: "Missing Details", message: errorMsg, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        return isValid
    }
    
}


// MARK: - UITextViewDelegate

extension MHPCreateEvent1DetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
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
            event?.description = textView.text
        }
    }
    
}


// MARK: - UITextFieldDelegate

extension MHPCreateEvent1DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtName.resignFirstResponder()
            txtDescription.becomeFirstResponder()
            return false
        case txtDescription:
            txtDescription.resignFirstResponder()
            txtLocationName.becomeFirstResponder()
        default:
            txtLocationName.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtName:
            event?.title = textField.text
        case txtLocationName:
            event?.location = textField.text
        default:
            return
        }
    }
    
    // add done button to keyboard
    func setupKeyboardDoneButton() {
        //init toolbar
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        
        // create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Next",
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(moveToLocationTextField))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
    
        // setting toolbar as inputAccessoryView
        self.txtDescription.inputAccessoryView = toolbar
    }
    
    @objc func moveToLocationTextField() {
        txtDescription.resignFirstResponder()
        txtLocationName.becomeFirstResponder()
    }
    
    func setupKeyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch> , with event: UIEvent?) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        event?.title = txtName.text
        event?.description = txtDescription.text
        event?.location = txtLocationName.text
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardFrame.height + 70
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}


// MARK: - LocationSearchSelectionDelegate

extension MHPCreateEvent1DetailsViewController: LocationSearchSelectionDelegate {
    func didSelectLocation(controller: MHPLocationSearchViewController, address: String) {
        btnLocationSearch.setTitle("", for: .normal)
        lblAddress.text = address
        event?.address = address
        btnClearAddress.isEnabled = true
        btnClearAddress.isHidden = false
    }
}


// MARK: - CreateEvent2DataDelegate

extension MHPCreateEvent1DetailsViewController: CreateEvent2DataDelegate {
    func back(event: MHPEvent) {
        inject(event)
    }
}

// MARK: - UserInjectable Protocol

extension MHPCreateEvent1DetailsViewController: Injectable {
    typealias T = MHPEvent
    typealias U = MHPUser

    func inject(_ event: T) {
        self.event = event
    }
    
    func inject(_ user: U) {
        self.mhpUser = user
    }
    
    func assertDependencies() {
        if event == nil {
            event = MHPEvent()
        }
        if let host = mhpUser {
            event?.host = host
        }
    }
}
