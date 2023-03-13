//
//  ViewController.swift
//  Project2
//
//  Created by Nezuko on 05/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var viewScore: UILabel!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var totalQuestion = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        
    }
    
    func askQuestion(action: UIAlertAction! = nil){
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
        viewScore.text = "Your score: \(score)"
        totalQuestion += 1
        
        if totalQuestion == 10 {
            let al = UIAlertController(title: "Finish!", message: "You have answered 10 question, thank you.", preferredStyle: .alert)
            al.addAction(UIAlertAction(title: "Okay", style: .default))
            present(al, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: \(score)", style: .plain, target: nil, action: Selector(("askQuestion")))
        
    }


    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            let ar = UIAlertController(title: "Wrong answer.", message: "Your answer is wrong, try again.", preferredStyle: .alert)
            ar.addAction(UIAlertAction(title: "Okay", style: .default))
            present(ar, animated: true)
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "You have been answered \(totalQuestion + 1) questions", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
}

