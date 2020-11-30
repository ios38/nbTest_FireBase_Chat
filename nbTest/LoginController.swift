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
    var loginView = LoginView()
    let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        self.view = loginView
        setUpBindings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Вход"

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
                        navigationController?.pushViewController(ViewController(), animated: true)
                    }
                }
            }.disposed(by: disposeBag)
        
        loginView.loginButton.rx.controlEvent(.touchUpInside)
            .subscribe { [unowned self] (_) in
                //print(">>>>> login button tapped")
                guard let email = loginView.loginTextField.text, let password = loginView.passwordTextField.text else { return }
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        navigationController?.pushViewController(ViewController(), animated: true)
                    }
                }
            }.disposed(by: disposeBag)
    }
}
