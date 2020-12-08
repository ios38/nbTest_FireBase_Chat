//
//  MessageCell.swift
//  nbTest
//
//  Created by Maksim Romanov on 08.12.2020.
//

import UIKit
import SnapKit

class MessageCell: UICollectionViewCell {
    let bubbleView = UIView()
    let textView = UITextView()
    var bubbleWidth: CGFloat? {
        didSet {
            bubbleView.snp.removeConstraints()
            bubbleView.snp.makeConstraints { (make) in
                make.top.bottom.trailing.equalToSuperview()
                make.width.equalTo(bubbleWidth ?? 200)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupBubbleView()
        setupTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBubbleView() {
        bubbleView.backgroundColor = .secondarySystemBackground
        bubbleView.layer.cornerRadius = 10
        contentView.addSubview(bubbleView)

        bubbleView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(bubbleWidth ?? 200)
        }
    }

    func setupTextView() {
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        bubbleView.addSubview(textView)

        textView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }
}
