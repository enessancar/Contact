//
//  ViewController.swift
//  Contact
//
//  Created by Enes Sancar on 27.05.2023.
//

import Contacts
import ContactsUI
import UIKit

final class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var models: [Person] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
    }
    
    private func addButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
    }
    
    @objc
    private func didTapAdd() {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
}

//MARK: - CNContactPickerDelegate
extension ViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = contact.givenName + " " + contact.familyName
        let identifier = contact.identifier
        let model = Person(name: name,
                           id: identifier,
                           source: contact)
        
        models.append(model)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableView DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].name
        return cell
    }
}

//MARK: - UITableView Delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = models[indexPath.row].source
        let vc = CNContactViewController(for: contact)
        vc.modalPresentationStyle = .none
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
