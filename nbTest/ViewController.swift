//
//  ViewController.swift
//  nbTest
//
//  Created by Maksim Romanov on 29.11.2020.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton: UIButton  = UIButton(type: .system)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 18)

        let logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)
        navigationItem.leftBarButtonItem = logoutBarButtonItem
        
        logoutButton.rx.controlEvent(.touchUpInside)
            .subscribe { [weak self] (_) in
                //print(">>>>> logout button tapped")
                do {
                    try Auth.auth().signOut()
                    self?.navigationController?.popViewController(animated: true)
                } catch {
                    print(error)
                }
            }.disposed(by: disposeBag)

    }


}

