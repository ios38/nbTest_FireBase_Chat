//
//  ChatView.swift
//  nbTest
//
//  Created by Maksim Romanov on 04.12.2020.
//

import UIKit
import SnapKit

class ChatView: UIView {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var sendView = UIView()
    var textField = UITextField()
    var sendButton = UIButton(type: .system)

    var collectionViewBottom: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSendView()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var inputAccessoryView: UIView? {
//        get {
//            return sendView
//        }
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }

    func setupSendView() {
        sendView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        sendView.backgroundColor = .secondarySystemBackground
        sendView.translatesAutoresizingMaskIntoConstraints = false
        //addSubview(sendView)
        /*
        sendView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sendView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        sendView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendViewBottom = sendView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        sendViewBottom?.isActive = true
        
        sendView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }*/

        setupSendButton()
        setupTextField()
    }

    func setupTextField() {
        textField.borderStyle = .roundedRect
        textField.placeholder = "Сообщение..."
        sendView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading).offset(10)
        }
    }

    func setupSendButton() {
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 18)
        sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        sendView.addSubview(sendButton)
        
        sendButton.snp.makeConstraints { (make) in
            make.width.equalTo(130)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 5
        }
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        addSubview(collectionView)

        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
        collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        collectionViewBottom?.isActive = true

        //collectionView.snp.makeConstraints { (make) in
        //    make.leading.equalToSuperview()
        //    make.trailing.equalToSuperview()
        //    make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(5)
        //    //make.bottom.equalTo(sendView.snp.top)
        //    make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        //}
    }
}
