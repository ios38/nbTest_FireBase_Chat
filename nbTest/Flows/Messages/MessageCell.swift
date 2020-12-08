//
//  MessageCell.swift
//  nbTest
//
//  Created by Maksim Romanov on 08.12.2020.
//

import UIKit

class MessageCell: UICollectionViewCell {
    let textView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTextView()
        backgroundColor = .secondarySystemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTextView() {
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Test"
        contentView.addSubview(textView)

        textView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(10)
        }
    }
}
