//
//  MHPLocationSearchViewController.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/25/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSearchSelectionDelegate: class {
    func didSelectLocation(controller: MHPLocationSearchViewController, address: String)
}

class MHPLocationSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSearchResults: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    weak var delegate: LocationSearchSelectionDelegate?
    lazy var geocoder = CLGeocoder()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        if let text = searchBar.text {
            searchCompleter.queryFragment = text
        }
        tblSearchResults.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: - UITableViewDelegate and Datasource

extension MHPLocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.attributedText = highlightedText(searchResult.title, inRanges: searchResult.titleHighlightRanges, size: 17.0)
        cell.detailTextLabel?.attributedText = highlightedText(searchResult.subtitle, inRanges: searchResult.subtitleHighlightRanges, size: 12.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedLocation = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: selectedLocation)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinates = response?.mapItems[0].placemark.coordinate
            let location = CLLocation(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                let address = self.processResponse(withPlacemarks: placemarks, error: error)
                self.delegate?.didSelectLocation(controller: self, address: address)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> String {
        if let error = error {
            return "Unable to Reverse Geocode Location \(error)"
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                return placemark.compactAddress!
            } else {
                return "No Matching Addresses Found"
            }
        }
    }
    
    func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let regular = UIFont.systemFont(ofSize: size)
        attributedText.addAttribute(.font, value: regular, range: NSMakeRange(0, text.count))
        
        let bold = UIFont.boldSystemFont(ofSize: size)
        for value in ranges {
            attributedText.addAttribute(.font, value: bold, range: value.rangeValue)
        }
        return attributedText
    }
}


// MARK: - UISearchBarDelegate

extension MHPLocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - MKLocalSearchCompleterDelegate

extension MHPLocationSearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async { [unowned self] in
            self.searchResults = completer.results
            self.tblSearchResults.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}
