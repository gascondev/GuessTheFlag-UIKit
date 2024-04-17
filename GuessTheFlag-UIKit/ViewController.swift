//
//  ViewController.swift
//  GuessTheFlag-UIKit
//
//  Created by Álvaro Gascón on 17/4/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var labelCountrie: UILabel!
    
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var numberOfQuestions = 0
    
    
    private var userScore: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        
        view.addSubview(userScore)
        
        func buttonConfig(button: UIButton) {
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        buttonConfig(button: button1)
        buttonConfig(button: button2)
        buttonConfig(button: button3)
        
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
    }
    
    
    
    // PRESENTATIONS
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        labelCountrie.text = countries[correctAnswer].uppercased()
    }
    
    // ACTIONS
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            numberOfQuestions += 1
        } else {
            title = "Wrong! This is from \(countries[sender.tag].capitalized)"
            score -= 1
            numberOfQuestions += 1
            if score < 0 {
                score = 0
            }
        }
        
        UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = .identity
                }
            }
        
        
        if numberOfQuestions < 5 {
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            let finalScoreMessage = "Your final score is \(score)."
            let ac = UIAlertController(title: title, message: finalScoreMessage, preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "End", style: .default) { _ in
                let restartAlert = UIAlertController(title: "Restart Game", message: "Do you want to play again?", preferredStyle: .alert)
                restartAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.resetCounters()
                    self.askQuestion()
                }))
                restartAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(restartAlert, animated: true, completion: nil)
            }
            ac.addAction(restartAction)
            
            present(ac, animated: true)
        }
    }
    
   @objc func showScore() {
        let ac = UIAlertController(title: "Score", message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func resetCounters() {
        score = 0
        numberOfQuestions = 0
    }
}

