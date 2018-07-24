//
//  MHPCreateEvent4RestrictionsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol CreateEvent4DataDelegate {
    func back(event: MHPEvent)
}

class MHPCreateEvent4RestrictionsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtDescription: UITextView!
    
    var btnInfo = UIBarButtonItem()
    var event: MHPEvent?
    var dataDelegate: CreateEvent4DataDelegate?
    let txtViewPlaceholderText = "Do any of your guests have dietary restirctions? For example, an allergy, special diet, or religious restriction? Please leave a note for your guests letting them know if some items will need to be free of certain ingredients."

    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        styleView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func styleView() {
        btnInfo = UIBarButtonItem(image: UIImage(named: "btnInfo.png"), style: .plain, target: self, action: #selector(infoTapped(_: )))
        navigationItem.rightBarButtonItem = btnInfo
        
        // set up scrollview + keyboard
        setupKeyboardDoneButton()
        setupKeyboardDismissOnTap()
        scrollView.keyboardDismissMode = .interactive
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // set values
        txtDescription.delegate = self
        if let desc = event?.restrictionDescription {
            txtDescription.text = desc
            txtDescription.textColor = .black
        } else {
            txtDescription.text = txtViewPlaceholderText
            txtDescription.textColor = .lightGray
        }
        
        // style description text view
        txtDescription.layer.borderColor = UIColor(hexString: "ebebeb").cgColor
        txtDescription.layer.borderWidth = 1.0
        txtDescription.layer.cornerRadius = 5
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func infoTapped(_ sender: Any) {
        showInfoPopup()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        next()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancel()
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func next() {
        if  let event = event,
            let createEvent5 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent5SaveAndSendViewController") as? MHPCreateEvent5SaveAndSendViewController {
            createEvent5.inject(event)
            navigationController?.pushViewController(createEvent5, animated: true)
        }
    }
    
    fileprivate func back() {
        if let event = event {
            dataDelegate?.back(event: event)
        }
    }
    
    fileprivate func cancel() {
        self.presentCancelAlert(view: self)
    }
}


// Mark: - Info Popover + UIPopoverPresentationControllerDelegate

extension MHPCreateEvent4RestrictionsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    fileprivate func showInfoPopup() {
        let infoPopover = storyboard?.instantiateViewController(withIdentifier: "MHPRestrictionsDefinitionsPopoverViewController") as! MHPRestrictionsDefinitionsPopoverViewController
        
        // set the presentation style
        infoPopover.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        infoPopover.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        infoPopover.popoverPresentationController?.delegate = self
        infoPopover.popoverPresentationController?.barButtonItem = btnInfo
        
        // present the popover
        self.present(infoPopover, animated: true, completion: nil)
    }
}


// MARK: - UITextView

extension MHPCreateEvent4RestrictionsViewController: UITextViewDelegate {
    
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
    
    // add done button to keyboard
    func setupKeyboardDoneButton() {
        //init toolbar
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        
        // create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        // setting toolbar as inputAccessoryView
        self.txtDescription.inputAccessoryView = toolbar
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
        event?.restrictionDescription = txtDescription.text
        // TODO: event?.restrictions =
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardFrame.height + 70
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

// MARK: - UserInjectable Protocol

extension MHPCreateEvent4RestrictionsViewController: Injectable {
    typealias T = MHPEvent
    
    func inject(_ event: T) {
        self.event = event
    }
    
    func assertDependencies() {
        assert(self.event != nil)
    }
}
