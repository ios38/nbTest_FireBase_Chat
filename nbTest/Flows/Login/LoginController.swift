//
//  LoginController.swift
//  nbTest
//
//  Created by Maksim Romanov on 02.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseDatabase

class LoginController: UIViewController {
    private var loginView = GbLoginView()
    private let disposeBag = DisposeBag()
    private var authListener: AuthStateDidChangeListenerHandle?

    override func loadView() {
        super.loadView()
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Вход"
        setUpBindings()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    override func viewWillAppear(_ animated: Bool) {
        authListener = Auth.auth().addStateDidChangeListener({ [unowned self] (auth, user) in
            guard user != nil else { return }
            let controller = GbViewController()
            controller.title = user?.email
            navigationController?.pushViewController(controller, animated: true)
            loginView.loginTextField.text = nil
            loginView.passwordTextField.text = nil
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }*/

    func setUpBindings() {
        loginView.registerButton.rx.controlEvent(.touchUpInside)
            .subscribe { [unowned self] (_) in
                //print(">>>>> register button tapped")
                guard let email = loginView.loginTextField.text, let password = loginView.passwordTextField.text else { return }
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error)
                    } else {
                        //Auth.auth().signIn(withEmail: email, password: password)
                        
                        guard let uid = result?.user.uid else { return }
                        let ref = Database.database().reference()
                        let userReference = ref.child("users").child(uid)
                        let values = ["email": email]
                        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                            if let error = error {
                                print(error)
                            }
                        })
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }.disposed(by: disposeBag)
        
        loginView.loginButton.rx.controlEvent(.touchUpInside)
            .subscribe { [unowned self] (_) in
                //print(">>>>> login button tapped")
                guard let email = loginView.loginTextField.text, let password = loginView.passwordTextField.text else { return }
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }.disposed(by: disposeBag)
    }

}
