//
//  ChatController.swift
//  nbTest
//
//  Created by Maksim Romanov on 03.12.2020.
//

import UIKit
import SnapKit

private let reuseIdentifier = "Cell"

class ChatController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat Controller"
        setupInputView()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func setupInputView() {
        let inputView = UIView()
        inputView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(inputView)
        
        inputView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        return cell
    }
}
