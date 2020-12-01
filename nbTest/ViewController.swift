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
import FirebaseDatabase

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var ads = [FireAd]()
    var adsRef = Database.database().reference(withPath: "ads")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuplogoutButton()
        setupRemoveButton()
        
        createFireAd(title: "Продам квартиру")
        
        adsRef.observe(.value) { [weak self] (allAdsSnapshot) in
            guard let self = self else { return }
            self.ads.removeAll()
            for adSnapshot in allAdsSnapshot.children {
                guard let snapshot = adSnapshot as? DataSnapshot,
                      let ad = FireAd(snapshot: snapshot) else { return }
                print(">>> \(ad.title) \(ad.date)")
                self.ads.append(ad)
            }
        }
    }

    private func removeFireAd() {
        guard let ad = ads.last else { return }
        ad.ref?.removeValue()
    }

    private func createFireAd(title: String) {
        let ad = FireAd(title: title, date: Date())
        
        let adRef = adsRef.child(title.lowercased())
        adRef.setValue(ad.toAnyObject())
    }

    private func setuplogoutButton() {
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

    private func setupRemoveButton() {
        let removeButton: UIButton  = UIButton(type: .system)
        removeButton.setTitle("Remove", for: .normal)
        removeButton.titleLabel?.font = .systemFont(ofSize: 18)
        
        let removeBarButtonItem = UIBarButtonItem(customView: removeButton)
        navigationItem.rightBarButtonItem = removeBarButtonItem
        
        removeButton.rx.controlEvent(.touchUpInside)
            .subscribe { [weak self] (_) in
                self?.removeFireAd()
            }.disposed(by: disposeBag)
    }

}

