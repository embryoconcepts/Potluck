//
//  MHPRestriction.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 7/25/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import UIKit

struct MHPEventRestriction: Codable, CollectionViewCompatible {

    var name: String
    var isSelected: Bool

    init(name: String) {
        self.name = name
        isSelected = false
    }

    init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }

    var reuseIdentifier: String {
        return "MHPRestrictionTagCell"
    }

    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MHPRestrictionTagCell", for: indexPath) as? MHPRestrictionTagCell else { return UICollectionViewCell() }
        cell.configureWithModel(self)
        return cell
    }
}
