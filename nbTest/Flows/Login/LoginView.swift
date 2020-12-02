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
    private var logoImageView = UIImageView()
    private var logoTitleLabel = UILabel()
    private var logoSubtitleLabel = UILabel()

    var loginTextField = UITextField()
    var passwordTextField = UITextField()

    var loginButton = UIButton(type: .system)
    var registerButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLogoImageView()
        setupLogoTitleLabel()
        setupLogoSubtitleLabel()
        setupLoginTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupRegisterButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        //view.backgroundColor = .systemGray5
        self.addSubview(view)

        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(400)
        }
    }

    private func setupLogoImageView() {
        logoImageView.clipsToBounds = true
        logoImageView.image = UIImage(systemName: "house.fill")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .secondaryLabel
        view.addSubview(logoImageView)

        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    private func setupLogoTitleLabel() {
        logoTitleLabel.text = "Соседи"
        logoTitleLabel.font = .systemFont(ofSize: 24)
        logoTitleLabel.textColor = .label
        view.addSubview(logoTitleLabel)

        logoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }

    private func setupLogoSubtitleLabel() {
        logoSubtitleLabel.text = "Общение • Голосования • Объявления"
        logoSubtitleLabel.font = .systemFont(ofSize: 14)
        logoSubtitleLabel.textColor = .secondaryLabel
        view.addSubview(logoSubtitleLabel)

        logoSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoTitleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }

    private func setupLoginTextField() {
        loginTextField.borderStyle = .roundedRect
        loginTextField.placeholder = "Имя пользователя или телефон"
        loginTextField.accessibilityIdentifier = "loginTextField"
        view.addSubview(loginTextField)

        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(logoSubtitleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }

    private func setupPasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Пароль"
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
