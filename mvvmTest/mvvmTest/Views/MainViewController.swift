//
//  MainViewController.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit
import Combine

class MainViewController: UIViewController, Storyboardable {
    
    var viewModel: MainViewModel?
    weak var coordinator: AppCoordinator?
    var cancallabels = Set<AnyCancellable>()
    
    var label = UILabel()
    var button = UIButton()
    
    var textField = UITextField()
    var labelWeather = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLabel()
        createButton()
        createTextField()
        createLabelWeather()
        view.backgroundColor = .white
        bindViewModel()
    }
    
    func bindViewModel() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .assign(to: \.!.city, on: viewModel)
            .store(in: &cancallabels)
        
        viewModel?.$curWeather
            .sink { [weak self] weather in
                if let temp = weather.main?.temp {
                    self?.labelWeather.text = String(temp) + " °C"
                } else {
                    self?.labelWeather.text = "..."
                }
                
            }
            .store(in: &cancallabels)
    }
}

//MARK: - createViews
extension MainViewController {
    func createLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        label.text = "Погода"
    }
    
    func createButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        button.setTitle("Подробнее", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(goNextScreen), for: .touchUpInside)
    }
    @objc func goNextScreen() {
        self.coordinator?.showDatail()
    }
    
    func createTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        textField.placeholder = "Введите город"
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        textField.backgroundColor = .gray
    }
    
    func createLabelWeather() {
        labelWeather.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelWeather)
        
        NSLayoutConstraint.activate([
            labelWeather.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            labelWeather.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }
}
