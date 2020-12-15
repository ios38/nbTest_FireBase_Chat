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
    
    var sendImage = UIButton(type: .system)
    var textField = UITextField()
    var sendButton = UIButton(type: .system)

    //var collectionViewBottom: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSendView()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func didMoveToWindow() {
//        super.didMoveToWindow()
//
//        if let window = self.window {
//            self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
//        }
//    }

    func setupSendView() {
        //sendView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        //sendView.backgroundColor = .secondarySystemBackground
        //sendView.translatesAutoresizingMaskIntoConstraints = false
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

        //setupSendButton()
        //setupTextField()
        
        sendView = CustomView()
        sendView.backgroundColor = .black
        sendView.autoresizingMask = .flexibleHeight

        //let textField = UITextField()
        //textField.placeholder = "Сообщение..."
        //textField.borderStyle = .roundedRect
        //textField.translatesAutoresizingMaskIntoConstraints = false
        //sendView.addSubview(textField)

        //textField.leadingAnchor.constraint(equalTo: sendView.leadingAnchor, constant: 8).isActive = true
        //textField.trailingAnchor.constraint(equalTo: sendView.trailingAnchor, constant: -8).isActive = true
        //textField.topAnchor.constraint(equalTo: sendView.topAnchor, constant: 8).isActive = true

        //// this is the important part :
        //textField.bottomAnchor.constraint(equalTo: sendView.layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true

        sendImage.setImage(UIImage(systemName: "camera"), for: .normal)
        sendImage.tintColor = .systemBlue
        sendView.addSubview(sendImage)

        textField.borderStyle = .roundedRect
        textField.placeholder = "Сообщение..."
        textField.backgroundColor = .secondarySystemBackground
        textField.setContentHuggingPriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        sendView.addSubview(textField)

        //sendButton.setTitle("Отправить", for: .normal)
        //sendButton.titleLabel?.font = .systemFont(ofSize: 18)
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        //sendButton.imageView?.clipsToBounds = true
        //sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.tintColor = .systemBlue
        sendView.addSubview(sendButton)
        
        sendImage.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalTo(textField.snp.centerY)
        }

        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            //make.leading.equalToSuperview().offset(10)
            make.leading.equalTo(sendImage.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            make.bottom.equalTo(sendView.layoutMarginsGuide.snp.bottom).inset(10)
        }

        sendButton.snp.makeConstraints { (make) in
            //make.width.equalTo(130)
            make.width.height.equalTo(40)
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalTo(textField.snp.centerY)
        }

    }

    func setupCollectionView() {
        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 5
        }
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        addSubview(collectionView)

        //collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        //collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
        //collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        //collectionViewBottom?.isActive = true

        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            //make.leading.equalToSuperview()
            //make.trailing.equalToSuperview()
            //make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(5)
            //make.bottom.equalToSuperview()
            //make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

class CustomView: UIView {

    // this is needed so that the inputAccesoryView is properly sized from
    // the auto layout constraints actual value is not important

    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}
