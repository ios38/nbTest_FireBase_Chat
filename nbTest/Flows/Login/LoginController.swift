//
//  LoginController.swift
//  nbTest
//
//  Created by Maksim Romanov on 02.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginController: UIViewController {
    private var loginView = LoginView()
    private let disposeBag = DisposeBag()
    private var authListener: AuthStateDidChangeListenerHandle?

    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Вход"
        setUpBindings()
        setupUserImagePicker()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    //override var preferredStatusBarStyle: UIStatusBarStyle {
    //    return .lightContent
    //}

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
                        
                        let imageName = UUID().uuidString
                        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                        
                        //let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                        
                        if let profileImage = loginView.userImageView.image,
                           let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                                if let error = error {
                                    print(error)
                                }
                                storageRef.downloadURL { (url, error) in
                                    if let error = error {
                                        print(error)
                                    }
                                    guard let userImageUrl = url?.absoluteString else { return }
                                    print (">>>>> \(userImageUrl)")
                                    let values = ["email": email, "profileImageUrl": userImageUrl]
                                    self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                                }
                            }
                        }
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

    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        //let values = ["email": email]
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if let error = error {
                print(error)
            }
        })
        //let user = User(dictionary: values)
        //self.messagesController?.setupNavBarWithUser(user)
        self.dismiss(animated: true, completion: nil)

    }

    func setupUserImagePicker() {
        loginView.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUserImage)))
    }

    @objc func handleSelectUserImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }

    @objc func hideKeyboard() {
        print("hideKeyboardGesture")
        view.endEditing(true)
        //loginView.endEditing(true)
        //loginView.loginTextField.resignFirstResponder()
    }

}

extension LoginController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image  = extractImage(info: info) {
            loginView.userImageView.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    private func extractImage(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
}
