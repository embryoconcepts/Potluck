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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnNext: UIButton!
    
    var mhpUser: MHPUser?
    let txtViewPlaceholderText = "Describe your event - let guests know if there is a theme, or a special occasion."
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.delegate = self
        txtLocation.delegate = self
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
        // TODO: add alert - do you really wanna?
        self.tabBarController?.tabBar.isHidden = false
        if let tabs = tabBarController?.viewControllers {
            if tabs.count > 0 {
                self.tabBarController?.selectedIndex = 0
            }
        }
        dismiss(animated: true, completion: nil)
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
        default:
            txtLocation.resignFirstResponder()
        }
        return true
    }
}
