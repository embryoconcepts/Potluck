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
        txtName.delegate = self
        txtDescription.delegate = self
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func pickerChanged(_ sender: Any) {
    
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
    
    
    // MARK: - Private methods
    
    fileprivate func setupView() {
        txtDescription.text = txtViewPlaceholderText
        txtDescription.textColor = .lightGray
        txtDescription.layer.borderColor = UIColor(hexString: "ebebeb").cgColor
        txtDescription.layer.borderWidth = 1.0
        txtDescription.layer.cornerRadius = 5
        
        datePicker.minimumDate = Date()
    }
    
    fileprivate func cancel() {
        let alert = UIAlertController(title: "Cancel Event",
                                      message: "Are you sure you want to cancel creating a Potluck? All event data will be lost.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { action in
            // TODO: improve clearing event handling
            self.event = nil
            self.txtName.text = ""
            self.txtDescription.text = self.txtViewPlaceholderText
            self.txtDescription.textColor = .lightGray
            self.datePicker.date = Date()
            self.txtLocationName.text = ""
            self.lblAddress.text = "Tap for Address Search"
            
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
        // TODO: save current values to user preferences, move to next screen
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
        }
    }
    
}


// MARK: - UITextFieldDelegate

extension MHPCreateEvent1DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtName.becomeFirstResponder()
        case txtDescription:
            txtDescription.becomeFirstResponder()
        case datePicker:
            datePicker.becomeFirstResponder()
        default:
            txtLocationName.resignFirstResponder()
        }
        return true
    }
}


// MARK: - LocationSearchSelectionDelegate

extension MHPCreateEvent1DetailsViewController: LocationSearchSelectionDelegate {
    func didSelectLocation(controller: MHPLocationSearchViewController, address: String) {
        lblAddress.text = address
    }
}
