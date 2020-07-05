//
//  MHPCreateEvent4RestrictionsViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/28/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit

protocol CreateEvent4DataDelegate: AnyObject {
    func back(event: MHPEvent)
}

class MHPCreateEvent4RestrictionsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var btnInfo = UIBarButtonItem()
    var event: MHPEvent?
    var dataDelegate: CreateEvent4DataDelegate?
    let txtViewPlaceholderText = "Do any of your guests have dietary restirctions? For example, an allergy, special diet, or religious restriction? Please leave a note for your guests letting them know if some items will need to be free of certain ingredients."
    var restrictionTags: [MHPEventRestriction]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assertDependencies()
        styleView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func styleView() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(back(sender: )))
        self.navigationItem.leftBarButtonItem = newBackButton

        btnInfo = UIBarButtonItem(image: UIImage(named: "btnInfo.png"), style: .plain, target: self, action: #selector(infoTapped(_: )))
        navigationItem.rightBarButtonItem = btnInfo

        // set up scrollview + keyboard
        setupKeyboardDoneButton()
        //        setupKeyboardDismissOnTap()
        scrollView.keyboardDismissMode = .interactive
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

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

        // collection tag cloud view
        tagCollectionView.layer.cornerRadius = 4
        tagCollectionView.allowsSelection = true
        tagCollectionView.allowsMultipleSelection = true

        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.estimatedItemSize = CGSize(width: 90, height: 30)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize

        // setup tags
        if let tags = event?.restrictions {
            restrictionTags = tags
        } else {
            restrictionTags = [MHPEventRestriction(name: "vegan"),
                               MHPEventRestriction(name: "vegetarian"),
                               MHPEventRestriction(name: "kosher"),
                               MHPEventRestriction(name: "halal"),
                               MHPEventRestriction(name: "gluten-free"),
                               MHPEventRestriction(name: "no nuts"),
                               MHPEventRestriction(name: "no dairy"),
                               MHPEventRestriction(name: "no eggs"),
                               MHPEventRestriction(name: "no meat"),
                               MHPEventRestriction(name: "no fish"),
                               MHPEventRestriction(name: "no shellfish"),
                               MHPEventRestriction(name: "no pork"),
                               MHPEventRestriction(name: "no soy")]
        }
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

    @IBAction func addTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: "Add Tag", message: "What dietary restriction tag would you like to add?", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "tag name..."
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _  in
                if let tag = alert.textFields?.first?.text {
                    self.restrictionTags!.append(MHPEventRestriction(name: tag, isSelected: true))
                    self.tagCollectionView.reloadData()
                }
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }


    // MARK: - Private Methods

    fileprivate func next() {
        saveEvent()
        if  let event = event,
            let createEvent5 = storyboard?.instantiateViewController(withIdentifier: "MHPCreateEvent5SaveAndSendViewController") as? MHPCreateEvent5SaveAndSendViewController {
            createEvent5.dataDelegate = self
            createEvent5.inject(event)
            navigationController?.pushViewController(createEvent5, animated: true)
        }
    }

    @objc fileprivate func back(sender: UIBarButtonItem) {
        saveEvent()
        if let event = event {
            dataDelegate?.back(event: event)
        }
        navigationController?.popViewController(animated: true)
    }

    fileprivate func cancel() {
        self.presentCancelAlert(view: self)
    }

    fileprivate func saveEvent() {
        if txtDescription.text != txtViewPlaceholderText {
            event?.restrictionDescription = txtDescription.text
        }

        event?.restrictions = restrictionTags

    }

}


// MARK: - CollectionView Delegate and Datasource

extension MHPCreateEvent4RestrictionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restrictionTags!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = restrictionTags![indexPath.row].cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath) as? MHPRestrictionTagCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        restrictionTags![indexPath.row].isSelected = !restrictionTags![indexPath.row].isSelected
        if !restrictionTags![indexPath.row].isSelected {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        self.tagCollectionView.reloadData()
    }
}


// MARK: - Info Popover + UIPopoverPresentationControllerDelegate

extension MHPCreateEvent4RestrictionsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    fileprivate func showInfoPopup() {
        guard let infoPopover = storyboard?.instantiateViewController(withIdentifier: "MHPRestrictionsDefinitionsPopoverViewController") as? MHPRestrictionsDefinitionsPopoverViewController else { return }

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
            event?.restrictionDescription = textView.text
        }
    }

    // add done button to keyboard
    func setupKeyboardDoneButton() {
        //init toolbar
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))

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

    //    func setupKeyboardDismissOnTap() {
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    //        self.view.addGestureRecognizer(tap)
    //    }
    //
    //    override func touchesBegan(_ touches: Set<UITouch> , with event: UIEvent?) {
    //        dismissKeyboard()
    //    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        event?.restrictionDescription = txtDescription.text
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


// MARK: - CreateEvent5DataDelegate

extension MHPCreateEvent4RestrictionsViewController: CreateEvent5DataDelegate {
    func back(event: MHPEvent) {
        inject(event)
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
