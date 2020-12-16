//
//  MessageCell.swift
//  nbTest
//
//  Created by Maksim Romanov on 08.12.2020.
//

import UIKit
import SnapKit

protocol ImageDetailing {
    func imageDetaiView (_ imageView: UIImageView)
}

class MessageCell: UICollectionViewCell {
    let bubbleView = UIView()
    let userImageView = UIImageView()
    let messageImageView = UIImageView()
    let textView = UITextView()
    /*
    var bubbleWidth: CGFloat? {
        didSet {
            bubbleView.snp.removeConstraints()
            bubbleView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.trailing.equalToSuperview().inset(5)
                make.width.equalTo(bubbleWidth ?? 200)
            }
        }
    }*/
    var bubbleWidth: NSLayoutConstraint?
    var bubbleLeading: NSLayoutConstraint?
    var bubbleTrailing: NSLayoutConstraint?
    
    var delegate: ImageDetailing?

    static let userMessageColor = UIColor.systemBlue.withAlphaComponent(0.7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUserImageView()
        setupBubbleView()
        setupTextView()
        setupMessageImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUserImageView() {
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 20
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = UIImage(systemName: "person.crop.circle")
        userImageView.isHidden = true
        contentView.addSubview(userImageView)

        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
    }

    func setupBubbleView() {
        
        bubbleView.backgroundColor = MessageCell.userMessageColor
        bubbleView.layer.cornerRadius = 10
        bubbleView.layer.masksToBounds = true
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)

        bubbleLeading = bubbleView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5)
        bubbleLeading?.isActive = false
        
        bubbleTrailing = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        bubbleTrailing?.isActive = true

        bubbleWidth = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidth?.priority = UILayoutPriority(rawValue: 999)
        bubbleWidth?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //bubbleView.snp.makeConstraints { (make) in
        //    make.top.bottom.equalToSuperview()
        //    make.trailing.equalToSuperview().inset(5)
        //    make.width.equalTo(bubbleWidth ?? 200)
        //}
    }

    func setupTextView() {
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        bubbleView.addSubview(textView)

        textView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }

    func setupMessageImageView() {
        messageImageView.clipsToBounds = true
        messageImageView.layer.cornerRadius = 10
        messageImageView.contentMode = .scaleAspectFill
        messageImageView.isHidden = true
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapAction(_:))))
        bubbleView.addSubview(messageImageView)

        messageImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func imageTapAction(_ recognizer: UITapGestureRecognizer) {
        if let imageView = recognizer.view as? UIImageView {
            delegate?.imageDetaiView(imageView)
        }
    }
}
