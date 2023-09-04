//
//  DetailsViewController.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit
import Combine

class DetailsViewController: UIViewController, Storyboardable {
    var viewModel: DetailViewModel?
    weak var coordinator: AppCoordinator?
    var cancellables = Set<AnyCancellable>()
    
    var mainLabel = UILabel()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    
    var buttonExit = UIButton()
    var switcher = UISwitch()
    
    var textField = UITextField()
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        view.backgroundColor = .white
        createMainLabel()
        createNameLabel()
        createEmailLabel()
        
        createButton()
        createSwitcher()
        
        createTextField()
        createLabel()
    }
    
    func updateUI() {
        nameLabel.text = "Name: \(String(describing: viewModel!.model!.name!))"
        emailLabel.text = "Email: \(String(describing: viewModel!.model!.email!))"
        
        viewModel?.$back
            .assign(to: \.isEnabled, on: buttonExit)
            .store(in: &cancellables)
        
        viewModel?.$back
            .sink { [weak self] switcherIsOn in
                if switcherIsOn {
                    self?.buttonExit.backgroundColor = .red
                } else {
                    self?.buttonExit.backgroundColor = .gray
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .filter { $0.count < 12 }
            .assign(to: \.!.textForReplay, on: viewModel)
            .store(in: &cancellables)
        
        viewModel?.$textForReplay
            .sink { [weak self] text in
                self?.label.text = text
            }
            .store(in: &cancellables)
    }
}

//MARK: - createViews
extension DetailsViewController {
    func createMainLabel() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        mainLabel.font = .boldSystemFont(ofSize: 24)
        mainLabel.text = "Информация"
    }
    
    func createNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 40),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }
    
    func createEmailLabel() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }
    
    func createButton() {
        buttonExit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonExit)
        
        NSLayoutConstraint.activate([
            buttonExit.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            buttonExit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            buttonExit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            buttonExit.heightAnchor.constraint(equalToConstant: 60)
        ])
        buttonExit.setTitle("Выйти", for: .normal)
        buttonExit.addTarget(self, action: #selector(goStartScreen), for: .touchUpInside)
    }
    @objc func goStartScreen() {
        coordinator?.showLogin()
    }
    
    func createSwitcher() {
        switcher.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            switcher.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            switcher.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        switcher.addTarget(self, action: #selector(switchChange), for: .touchUpInside)
    }
    @objc func switchChange() {
        viewModel?.back = switcher.isOn
    }
    
    func createTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: switcher.bottomAnchor, constant: 20),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        textField.placeholder = "Введите текст"
        textField.backgroundColor = .gray
    }
    
    func createLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }
}
