//
//  ViewController2.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit
import Combine

class ScoreViewController: UIViewController, Storyboardable {
    var scoreLabel = UILabel()
    var incButton = UIButton()
    var nextButton = UIButton()
    
    var viewModel: ScoreViewModel?
    weak var coordinator: AppCoordinator?
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        createScoreLabel()
        createIncButton()
        createNextButton()
        
        bindViewModel2()
    }
    
    func bindViewModel2() {
        viewModel?.$score
            .sink { [weak self] score in
                self?.scoreLabel.text = String(score)
            }
            .store(in: &cancellable)
        
        viewModel?.isThirdScore
            .assign(to: \.isEnabled, on: nextButton)
            .store(in: &cancellable)
        
        viewModel?.isThirdScore
            .sink { [weak self] scoreIsThree in
                if scoreIsThree {
                    self?.view.backgroundColor = .yellow
                    self?.incButton.backgroundColor = .gray
                    self?.incButton.isEnabled = false
                    self?.nextButton.backgroundColor = .blue
                } else {
                    self?.view.backgroundColor = .green
                    self?.incButton.backgroundColor = .blue
                    self?.nextButton.backgroundColor = .gray
                }
            }
            .store(in: &cancellable)
    }
}

//MARK: - createViews
extension ScoreViewController {
    func createScoreLabel() {
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        scoreLabel.text = "0"
    }
    
    func createIncButton() {
        incButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(incButton)
        
        NSLayoutConstraint.activate([
            incButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 80),
            incButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
            incButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
            incButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        incButton.setTitle("+", for: .normal)
        incButton.setTitleColor(.black, for: .normal)
        incButton.backgroundColor = .blue
        incButton.layer.cornerRadius = 12
        
        incButton.addTarget(self, action: #selector(incScore), for: .touchUpInside)
    }
    @objc func incScore() {
        viewModel?.scoreButtonPressed()
        
    }
    
    func createNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        nextButton.setTitle("Дальше", for: .normal)
        nextButton.backgroundColor = .blue
        nextButton.layer.cornerRadius = 12
        
        nextButton.addTarget(self, action: #selector(goNextScreen), for: .touchUpInside)
    }
    @objc func goNextScreen() {
        coordinator?.showMain(login: User.logins[0].login ?? "Не определен" )
    }
}
