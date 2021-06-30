//
//  Contacts.swift
//  Contacts_Usov
//
//  Created by Андрей Бородкин on 30.06.2021.
//

import Foundation

protocol ContactProtocol {
    // Name
    var title: String {get set}
    // Phone Number
    var phone: String {get set}
}

struct Contact: ContactProtocol {
    var title: String
    var phone: String
}
