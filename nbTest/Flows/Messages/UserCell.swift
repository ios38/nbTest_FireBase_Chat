//
//  UserCell.swift
//  nbTest
//
//  Created by Maksim Romanov on 03.12.2020.
//

import UIKit
import Firebase
import SnapKit

class UserCell: UITableViewCell {
    var userImageView = UIImageView()
    var nameLabel = UILabel()
    var dateLabel = UILabel()
    private let dateFormatter = DateFormatter()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dateFormatter.dateFormat = "d MMM, HH:mm" //"20-11-24 10:19"

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 20
        userImageView.contentMode = .scaleAspectFit
        contentView.addSubview(userImageView)

        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5).priority(999)
        }

        //nameLabel.font = UIFont.systemFont(ofSize: 14)
        //nameLabel.textColor = .secondaryLabel
        //nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImageView.snp.centerY)
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            //make.trailing.equalToSuperview().inset(10)
        }

        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel
        //dateLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        contentView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImageView.snp.centerY)
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }

    }
    
    func configure(user: User) {
        self.nameLabel.text = user.email

        if let profileImageUrl = user.profileImageUrl, let url = URL(string: profileImageUrl) {
            self.userImageView.kf.setImage(with: url)
        }
    }

    func configure(message: Message) {
        if let id = message.chatPartnerId() {
            self.setupUser(id: id)
            let date = Date(timeIntervalSince1970: message.date!)
            self.dateLabel.text = self.dateFormatter.string(from: date)
        }
    }

    private func setupUser(id: String) {
        let ref = Database.database().reference().child("users").child(id)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(dictionary: dictionary)

            if let profileImageUrl = user.profileImageUrl, let url = URL(string: profileImageUrl) {
                self?.userImageView.kf.setImage(with: url)
            }

            self?.nameLabel.text = user.email
        }

    }

}
/*
class ChatUserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    private func setupNameAndProfileImage() {
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}*/
