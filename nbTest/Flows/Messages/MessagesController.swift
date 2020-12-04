//
//  MessagesController.swift
//  nbTest
//
//  Created by Maksim Romanov on 02.12.2020.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessagesController: UITableViewController {
    var messages = [Message]()
    var messagesDict = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MessagesController.handleLogout))
        
        let image = UIImage(systemName: "square.and.pencil")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(MessagesController.handleNewMessage))

        tableView.register(UserCell.self, forCellReuseIdentifier: "Cell")
        checkIfUserIsLoggedIn()
        observeMessages()
    }

    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded) { [unowned self] (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                
                if let toId = message.toId {
                    self.messagesDict[toId] = message
                }
                
                self.messages = Array(self.messagesDict.values)
                self.messages.sort { $0.date! > $1.date! }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["email"] as? String
                }
            })
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let login = LoginController()
        present(login, animated: true, completion: nil)
    }

    @objc func showChatWithUser(_ user: User) {
        let chatController = ChatController()
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UserCell
        let message = messages[indexPath.row]
        cell.configure(message: message)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //showChatWithUser()
    }

}
