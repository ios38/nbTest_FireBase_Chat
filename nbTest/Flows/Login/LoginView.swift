//
//  LoginView.swift
//  neighbor
//
//  Created by Maksim Romanov on 21.10.2020.
//

import UIKit
import SnapKit

class LoginView: UIView {
    private var view = UIView()
    lazy var userImageView = UIImageView()

    var loginTextField = UITextField()
    var passwordTextField = UITextField()

    var loginButton = UIButton(type: .system)
    var registerButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupUserImageView()
        setupLoginTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupRegisterButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        //self.backgroundColor = .black
        //view.backgroundColor = .blue
        self.addSubview(view)

        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(350)
        }
    }

    private func setupUserImageView() {
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 30
        userImageView.image = UIImage(systemName: "house.fill")
        userImageView.contentMode = .scaleAspectFit
        userImageView.tintColor = .secondaryLabel
        userImageView.isUserInteractionEnabled = true

        view.addSubview(userImageView)

        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    private func setupLoginTextField() {
        loginTextField.borderStyle = .roundedRect
        loginTextField.placeholder = "email"
        loginTextField.accessibilityIdentifier = "loginTextField"
        view.addSubview(loginTextField)

        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }

    private func setupPasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "password"
        passwordTextField.accessibilityIdentifier = "passwordTextField"
        view.addSubview(passwordTextField)

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }

    private func setupLoginButton() {
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18)
        loginButton.backgroundColor = .systemGray6
        loginButton.layer.cornerRadius = 10
        loginButton.accessibilityIdentifier = "loginButton"
        view.addSubview(loginButton)

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(56)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setupRegisterButton() {
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 18)
        registerButton.backgroundColor = .systemGray6
        registerButton.layer.cornerRadius = 10
        registerButton.accessibilityIdentifier = "registerButton"
        view.addSubview(registerButton)

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(self.loginButton.snp.bottom).offset(20)
            make.height.equalTo(56)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }

}
