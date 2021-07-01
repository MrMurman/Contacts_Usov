//
//  ViewController.swift
//  Contacts_Usov
//
//  Created by Андрей Бородкин on 30.06.2021.
//

import UIKit

// MARK: - Extensions
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    
        
//        //trying to load a reusable cell
//        guard var cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") else {
//            print("Создаём новую ячейку для строки с индексом \(indexPath.row)")
//        var newCell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
//            configure(cell: &newCell, for: indexPath)
//
//            return newCell
//        }
//        print("Используем старую ячейку для строки с индексом \(indexPath.row)")
//        configure(cell: &cell, for: indexPath)
//        return cell
        
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        
        // мы проверяем на соответствие системы, если она иОС 14 и новее, то юзаем данный способ. В противном случае, работаем по старинке
        if #available(iOS 14, *) {
            var configuration = cell.defaultContentConfiguration()
            // имя контакта
            configuration.text = contacts[indexPath.row].title
            // номер телефона контакта
            configuration.secondaryText = contacts[indexPath.row].phone
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = contacts[indexPath.row].title
            cell.detailTextLabel?.text = contacts[indexPath.row].phone
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //print("Определеяем доступные действия для строки \(indexPath.row)")
        
        // deletion
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
            // deleting contact
            self.contacts.remove(at: indexPath.row)
            
            // reloads tableView
            tableView.reloadData()
        }
        // form an instance  that describes possible actions
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}

// MARK: - Variables declaration


class ViewController: UIViewController {

    
    //var userDefaults = UserDefaults.standard
    var storage: ContactStorageProtocol!
    
    public var contacts = [ContactProtocol]() {
        didSet {
            contacts.sort{ $0.title < $1.title }
            //actually saves contacts to storage
            storage.save(contacts: contacts)
        }
    }
    
    
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
        
        // No longer needed stuff
        //userDefaults.set("Some random text", forKey: "Some key")
       // print(userDefaults.object(forKey: "Some key"))
        //print(userDefaults.string(forKey: "Some key"))
    }


    private func loadContacts() {
        
        contacts = storage.load()
        
        
        
        // test contacts
//        contacts.append(Contact(title: "Саня Техосмотр", phone: "+79991231232"))
//        contacts.append(Contact(title: "Владимир Петухов", phone: "+78121334321"))
//        contacts.append(Contact(title: "Сильвестр", phone: "+7000911112"))
        //contacts.sort{ $0.title < $1.title } -- no longer needed after adding didSet to var declaration
    }
    
    @IBAction func showNextContactAlert() {
       // Alert Controlled creation
        let alertController = UIAlertController(title: "Создайте новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        
            // first text field creation
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        // second text field creation
        alertController.addTextField { textField in
                textField.placeholder = "Номер телефона"
        }
            
        // buttons creation
        // add contact button
        let createButton = UIAlertAction(title: "Создать", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                    let contactPhone = alertController.textFields?[1].text else {return}
                
            // new contact creation
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
                
            //note to myself -- try to insert at indexPath.row instead of reloading whole tablеView/
            // On the second thought -- I shouldn't as contact should be added in alphabetic order
        }
            
        // cancel button
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
            
        // add buttons to alert controller
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
            
        // display Alert Controller
        present(alertController, animated: true, completion: nil)
    }
    
}

