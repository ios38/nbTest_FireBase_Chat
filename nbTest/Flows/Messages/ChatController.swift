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

    override func loadView() {
        super.loadView()
        self.view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat Controller"

        chatView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        chatView.textField.delegate = self
        chatView.sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
    }

    @objc func sendButtonAction() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let text = chatView.textField.text, !text.isEmpty else { return }
        let values = ["text": text, "name": "Max"] as [String: Any]
        childRef.updateChildValues(values)
    }
}

extension ChatController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
        return cell
    }
}

extension ChatController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonAction()
        return true
    }
}
