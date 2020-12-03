//
//  NewMessageController.swift
//  nbTest
//
//  Created by Maksim Romanov on 02.12.2020.
//

import UIKit
import FirebaseDatabase

class NewMessageController: UITableViewController {
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        tableView.register(UserCell.self, forCellReuseIdentifier: "Cell")

        fetchUser()
    }

    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            //print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //let user = User(email: (dictionary["email"] as? String)) //FIXME: add User init from DataSnapshot
                let user = User(dictionary: dictionary) //FIXME: add User init from DataSnapshot
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].email
        return cell
    }
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
