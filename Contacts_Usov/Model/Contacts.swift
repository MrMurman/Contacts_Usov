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


protocol ContactStorageProtocol {
    // contact list loading
    func load() -> [ContactProtocol]
    // contact list refresh
    func save(contacts: [ContactProtocol])
}

class ContactStorage: ContactStorageProtocol {
    // storage link
    private var storage = UserDefaults.standard
    // storage key used to save data
    private var storageKey = "contacts"
    
    // enumeration with keys for User Defaults
    private enum ContactKey: String {
        case title
        case phone
    }
    
    //alternatively we can declare to vars here
//    private var keyTitle = ContactKey(rawValue: "title")
//    private var keyPhone = ContactKey(rawValue: "phone")
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            
             //and likewise here. However, here we have a safety mechanism to unleash optionals
//            for contact in contactsFromStorage {
//                guard let title = contact[keyTitle!.rawValue],
//                      let phone = contact[keyPhone!.rawValue] else {
//                    continue
//                }
            
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String:String]] = []
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            
            // and really we can just do the following, but this way is prone to massive mistake outburst
//            newElementForStorage[keyTitle!.rawValue] = contact.title
//            newElementForStorage[keyPhone!.rawValue] = contact.phone
            
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            print("title added", newElementForStorage)
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            print("phone added", newElementForStorage)
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
