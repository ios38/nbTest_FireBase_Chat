//
//  LoginController.swift
//  neighbor
//
//  Created by Kirill Titov on 18.10.2020.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class LoginController: UIViewController {
    private var loginView = LoginView()
    private let disposeBag = DisposeBag()
    private var authListener: AuthStateDidChangeListenerHandle?

    override func loadView() {
        super.loadView()
        self.view = loginView
        setUpBindings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Вход"
    }

    override func viewWillAppear(_ animated: Bool) {
        authListener = Auth.auth().addStateDidChangeListener({ [unowned self] (auth, user) in
            guard user != nil else { return }
            let controller = ViewController()
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
    }
    func setUpBindings() {
        loginView.registerButton.rx.controlEvent(.touchUpInside)
            .subscribe { [unowned self] (_) in
                //print(">>>>> register button tapped")
                guard let email = loginView.loginTextField.text, let password = loginView.passwordTextField.text else { return }
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        Auth.auth().signIn(withEmail: email, password: password)
                    }
                }
            }.disposed(by: disposeBag)
        
        loginView.loginButton.rx.controlEvent(.touchUpInside)
            .subscribe { [unowned self] (_) in
                //print(">>>>> login button tapped")
                guard let email = loginView.loginTextField.text, let password = loginView.passwordTextField.text else { return }
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                }
            }.disposed(by: disposeBag)
    }
}
