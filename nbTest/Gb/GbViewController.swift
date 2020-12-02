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
import FirebaseFirestore

class GbViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var ads = [FirebaseAd]()
    var adsRef = Database.database().reference(withPath: "ads")
    private let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //"2020-11-24 10:19:17 +0000"

        setuplogoutButton()
        //setupRemoveButton()
        
        createFireAd(title: "Продам квартиру")
        
        adsRef.observe(.value) { [weak self] (allAdsSnapshot) in
            guard let self = self else { return }
            self.ads.removeAll()
            for adSnapshot in allAdsSnapshot.children {
                guard let snapshot = adSnapshot as? DataSnapshot,
                      let ad = FirebaseAd(snapshot: snapshot) else { return }
                print(">>> \(ad.title) \(ad.date)")
                self.ads.append(ad)
                let firestoreAd = FirestoreAd(title: ad.title, date: ad.date)
                self.saveToFirestore(firestoreAd)
            }
        }
    }

    private func removeFireAd() {
        guard let ad = ads.last else { return }
        ad.ref?.removeValue()
    }

    private func createFireAd(title: String) {
        let ad = FirebaseAd(title: title, date: Date())
        
        let adRef = adsRef.child(title.lowercased())
        adRef.setValue(ad.toAnyObject())
    }

    
    func saveToFirestore(_ ad: FirestoreAd) {
        Firestore.firestore()
            .collection("ads")
            .document(dateFormatter.string(from: ad.date))
            .setData(ad.toAnyObject())
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

