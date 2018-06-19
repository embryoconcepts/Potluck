//
//  MHPResponseHandler.swift
//  Potluck
//
//  Created by Jennifer Hamilton on 6/17/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import Foundation
import Firebase

/// Receives the data response, sends it to the correct parser for the selected service
struct MHPDataManager {
    private let service: ServiceOption
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(service: ServiceOption = appDelegate.serviceOption) {
        self.service = service
    }
    
    func encodeUser(firUserEmail: String?, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any] {
        return service.parser.buildDataSet(firUserEmail: firUserEmail, mhpUser: mhpUser, firstName: firstName, lastName: lastName, state: state)
    }
    
    func decodeUser(document: DocumentSnapshot, data: [String: Any]) -> MHPUser {
        return service.parser.parseResponseToUser(document: document, data: data)
    }
}
