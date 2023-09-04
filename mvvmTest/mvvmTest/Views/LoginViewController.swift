//
//  ViewController.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit
import Combine

class LoginViewController: UIViewController, Storyboardable {
    var textFieldLogin = UITextField()
    var textFieldPassword = UITextField()
    var button = UIButton()
    var label = UILabel()

    var viewModel: LoginViewModel?
    var cancellable = Set<AnyCancellable>()
    weak var coordinator: AppCoordinator?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        
        createLoginTextField()
        createPasswordTextField()
        createButton()
        createLabel()
        
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    }

    
    func bindViewModel() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textFieldLogin)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.!.email, on: viewModel)
            .store(in: &cancellable)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textFieldPassword)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.!.password, on: viewModel)
            .store(in: &cancellable)
        
        viewModel?.isLoginEnabled
            .assign(to: \.isEnabled, on: button)
            .store(in: &cancellable)
        
        viewModel?.isLoginEnabled
            .sink { [weak self] login in
                if login {
                    self?.button.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                    self?.label.isHidden = true
                } else {
                    self?.button.backgroundColor = .gray
                    self?.label.isHidden = true
                }
                
            }
            .store(in: &cancellable)
        
        viewModel?.$state
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.button.isEnabled = false
                    self?.button.setTitle("Loading...", for: .normal)
                    self?.button.backgroundColor = .gray
                    self?.label.isHidden = true
                case .success:
                    self?.button.setTitle("Login", for: .normal)
                    self?.button.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                    self?.label.text = "Успешно, переход на следующий экран..."
                    self?.label.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
                    self?.label.isHidden = false
                    self?.coordinator?.showScore()
                case .failed:
                    self?.button.setTitle("Login", for: .normal)
                    self?.label.text = "Проверьте введенные данные"
                    self?.label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    self?.label.isHidden = false
                case .none:
                    self?.button.setTitle("Login", for: .normal)
                    self?.label.isHidden = true
                    //break
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: - create views
extension LoginViewController {
    func createLoginTextField() {
        textFieldLogin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldLogin)
        
        NSLayoutConstraint.activate([
            textFieldLogin.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textFieldLogin.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textFieldLogin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            textFieldLogin.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        textFieldLogin.placeholder = "Login"
        textFieldLogin.borderStyle = .roundedRect
        textFieldLogin.autocorrectionType = .no
    }
    
    func createPasswordTextField() {
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldPassword)
        
        NSLayoutConstraint.activate([
            textFieldPassword.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textFieldPassword.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textFieldPassword.topAnchor.constraint(equalTo: textFieldLogin.bottomAnchor, constant: 20),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        textFieldPassword.placeholder = "Password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.autocorrectionType = .no
    }
    
    func createButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            button.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 20),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 14
        
        button.addTarget(self, action: #selector(checkLogin), for: .touchUpInside)
    }
    @objc func checkLogin() {
        viewModel?.submitLogin()
    }
    
    func createLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        label.textAlignment = .center
    }
}

