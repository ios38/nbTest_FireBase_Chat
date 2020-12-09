//
//  ChatController.swift
//  nbTest
//
//  Created by Maksim Romanov on 03.12.2020.
//

import UIKit
import SnapKit
import Firebase

class ChatController: UIViewController {
    private var chatView = ChatView()
    var messages = [Message]()
    var user: User? {
        didSet {
            title = user?.email
            observeMessages()
        }
    }

    var bubbleWidth: CGFloat = 300
    
    override func loadView() {
        super.loadView()
        self.view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chatView.collectionView.dataSource = self
        chatView.collectionView.delegate = self
        chatView.textField.delegate = self
        chatView.sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        bubbleWidth = view.frame.size.width - 100
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chatView.collectionView.collectionViewLayout.invalidateLayout()
    }

    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userMessageRef = Database.database().reference().child("user_messages").child(uid)
        userMessageRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message(dictionary: dictionary)
                
                if message.chatPartnerId() == self?.user?.id {
                    self?.messages.append(message)
                    DispatchQueue.main.async {
                        self?.chatView.collectionView.reloadData()
                    }
                }                
            }
        }
    }

    @objc func sendButtonAction() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let text = chatView.textField.text,
              !text.isEmpty,
              let toId = user?.id,
              let fromId = Auth.auth().currentUser?.uid
        else { return }
        let date = Date().timeIntervalSince1970
        let values = ["text": text, "toId": toId, "fromId": fromId, "date": date] as [String: Any]
        childRef.updateChildValues(values) { [weak self] (error, ref) in
            if let error = error {
                print(error)
                return
            }

            self?.chatView.textField.text = nil
            
            let userMessageRef = Database.database().reference().child("user_messages").child(fromId)
            guard let messageId = childRef.key else { return }
            userMessageRef.updateChildValues([messageId: 0])
            
            let recipientRef = Database.database().reference().child("user_messages").child(toId)
            recipientRef.updateChildValues([messageId: 0])
        }
    }
}

extension ChatController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.item]
        if let text = message.text {
            let bubbleWidth = estimateFrameForText(text: text).width + 25
            //cell.bubbleWidth = bubbleWidth
            cell.bubbleWidth?.constant = bubbleWidth
            cell.textView.text = text
            setupCell(cell, message: message)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 100
        
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }

    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: bubbleWidth, height: 500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setupCell(_ cell: MessageCell, message: Message) {
        if let profileImageUrl = user?.profileImageUrl, let url = URL(string: profileImageUrl) {
            cell.userImageView.kf.setImage(with: url)
        }

        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = MessageCell.userMessageColor
            cell.userImageView.isHidden = true
            cell.bubbleLeading?.isActive = false
            cell.bubbleTrailing?.isActive = true
        } else {
            cell.bubbleView.backgroundColor = .secondarySystemBackground
            cell.userImageView.isHidden = false
            cell.bubbleLeading?.isActive = true
            cell.bubbleTrailing?.isActive = false
        }
    }
}

extension ChatController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonAction()
        return true
    }
}
