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
        self.view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chatView.collectionView.dataSource = self
        chatView.collectionView.delegate = self
        chatView.collectionView.keyboardDismissMode = .interactive
        chatView.collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)

        chatView.textField.delegate = self
        chatView.sendImage.addTarget(self, action: #selector(sendImageAction), for: .touchUpInside)
        chatView.sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        
        setupKeyboardObservers()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        bubbleWidth = view.frame.size.width - 100
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chatView.collectionView.collectionViewLayout.invalidateLayout()
    }
    //var sendView: UIView!
    
    override var inputAccessoryView: UIView? {
        return chatView.sendView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardWillShow(notification: Notification) {
        //print("handleKeyboardWillShow")
        let info = notification.userInfo! as NSDictionary
        //let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let keyboardFrame = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect
        //let keyboardDuration = info.value(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        chatView.collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: keyboardFrame.height, right: 0)
        //chatView.collectionViewBottom?.constant = chatView.safeAreaInsets.bottom - keyboardFrame.height
        //UIView.animate(withDuration: keyboardDuration) {
        //    self.view.layoutIfNeeded()
        //}
    }

    @objc func handleKeyboardWillHide(notification: Notification) {
        //print("handleKeyboardWillHide")
        //let info = notification.userInfo! as NSDictionary
        //let keyboardDuration = info.value(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        chatView.collectionView.contentInset = .zero
        //chatView.collectionViewBottom?.constant = 0
        //UIView.animate(withDuration: keyboardDuration) {
        //    self.view.layoutIfNeeded()
        //}
    }

    @objc func hideKeyboard() {
        print("hideKeyboardGesture")
        chatView.textField.resignFirstResponder()
    }

    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
        let userMessageRef = Database.database().reference().child("user_messages").child(uid).child(toId)
        userMessageRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message(dictionary: dictionary)
                self?.messages.append(message)
                DispatchQueue.main.async {
                    self?.chatView.collectionView.reloadData()
                }
            }
        }
    }

    @objc func sendImageAction() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }

    @objc func sendButtonAction() {
        /*
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let text = chatView.textField.text,
              !text.isEmpty,
              let toId = user?.id,
              let fromId = Auth.auth().currentUser?.uid
        else { return }
        let date = Date().timeIntervalSince1970
        let values = ["text": text, "toId": toId, "fromId": fromId, "date": date] as [String: Any]
         */
        guard let text = chatView.textField.text, !text.isEmpty else { return }
        let properties = ["text": text]
        sendMessage(with: properties)
        self.chatView.textField.text = nil
        self.chatView.textField.resignFirstResponder()

        /*
        childRef.updateChildValues(values) { [weak self] (error, ref) in
            if let error = error {
                print(error)
                return
            }

            self?.chatView.textField.text = nil
            self?.chatView.textField.resignFirstResponder()
            //self?.view.endEditing(true)

            let userMessageRef = Database.database().reference().child("user_messages").child(fromId).child(toId)
            guard let messageId = childRef.key else { return }
            userMessageRef.updateChildValues([messageId: 0])
            
            let recipientRef = Database.database().reference().child("user_messages").child(toId).child(fromId)
            recipientRef.updateChildValues([messageId: 0])
        }*/
    }

    private func sendMessage(with properties: [String: Any]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let fromId = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
        let date = Date().timeIntervalSince1970
        
        var values = ["toId": toId, "fromId": fromId, "date": date] as [String: Any]
        
        //properties.forEach { (key: String, value: Any) in
        //    values[key] = value
        //}
        properties.forEach { values[$0] = $1 }
        
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }

            let userMessageRef = Database.database().reference().child("user_messages").child(fromId).child(toId)
            guard let messageId = childRef.key else { return }
            userMessageRef.updateChildValues([messageId: 0])
            
            let recipientRef = Database.database().reference().child("user_messages").child(toId).child(fromId)
            recipientRef.updateChildValues([messageId: 0])
        }

    }

    private func sendMessageWithImage(_ imageUrl: String, image: UIImage) {
        /*
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let fromId = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
        let date = Date().timeIntervalSince1970
        
        let values = ["toId": toId, "fromId": fromId, "date": date, "imageUrl": imageUrl, "imageWidht": imageWidht, "imageHeight": imageHeight] as [String: Any]
        */
        let imageWidht = image.size.width
        let imageHeight = image.size.height

        let properties = ["imageUrl": imageUrl, "imageWidht": imageWidht, "imageHeight": imageHeight] as [String: Any]

        sendMessage(with: properties)
        /*
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print(error)
                return
            }

            let userMessageRef = Database.database().reference().child("user_messages").child(fromId).child(toId)
            guard let messageId = childRef.key else { return }
            userMessageRef.updateChildValues([messageId: 0])
            
            let recipientRef = Database.database().reference().child("user_messages").child(toId).child(fromId)
            recipientRef.updateChildValues([messageId: 0])
        }*/
    }

    private func uploadImage(_ image: UIImage) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("message_images").child(imageName)
        guard let uploadData = image.jpegData(compressionQuality: 0.1) else { return }
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            }
            storageRef.downloadURL { [weak self] (url, error) in
                if let error = error {
                    print(error)
                }
                guard let userImageUrl = url?.absoluteString else { return }
                self?.sendMessageWithImage(userImageUrl, image: image)
            }
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
            let bubbleWidth = ceil(estimateFrameForText(text: text).width) + 25
            //cell.bubbleWidth = bubbleWidth
            cell.bubbleWidth?.constant = bubbleWidth
            cell.textView.text = text
        }
        
        if let imageWidht = messages[indexPath.item].imageWidht, let imageHeight = messages[indexPath.item].imageHeight {
            cell.bubbleWidth?.constant = 200
        }

        setupCell(cell, message: message)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 200
        
        if let text = messages[indexPath.item].text {
            //width = ceil(estimateFrameForText(text: text).width) + 25
            height = estimateFrameForText(text: text).height + 20
        }
        
        if let imageWidht = messages[indexPath.item].imageWidht, let imageHeight = messages[indexPath.item].imageHeight {
            height = 200 * CGFloat(imageHeight / imageWidht)
            //print(height)
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

        if let messageImageUrl = message.imageUrl, let url = URL(string: messageImageUrl) {
            cell.messageImageView.isHidden = false
            cell.messageImageView.kf.setImage(with: url)
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
        chatView.textField.resignFirstResponder()
        return true
    }
}

extension ChatController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image  = extractImage(info: info) {
            uploadImage(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    private func extractImage(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
}
