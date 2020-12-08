//
//  ChatView.swift
//  nbTest
//
//  Created by Maksim Romanov on 04.12.2020.
//

import UIKit

class ChatView: UIView {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var sendView = UIView()
    var textField = UITextField()
    var sendButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSendView()
        setupSendButton()
        setupTextField()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSendView() {
        sendView.backgroundColor = .secondarySystemBackground
        
        addSubview(sendView)
        
        sendView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
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
        //collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        //    layout.itemSize = CGSize(width: frame.width, height: 80)
        //    layout.scrollDirection = .vertical
        //    layout.minimumLineSpacing = 3
        //}
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(sendView.snp.top)
        }
    }
}
