//
//  ViewController.swift
//  lifecounter
//
//  Created by 小戈 on 2024/4/14.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var player1LifeLabel: UILabel!
    @IBOutlet weak var player2LifeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var player1StackView: UIStackView!
    @IBOutlet weak var player2StackView: UIStackView!
    @IBOutlet weak var parentStackView: UIStackView!
    
    var lifeTotalPlayer1 = 20
    var lifeTotalPlayer2 = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func chooseAction(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)
        let player = sender.tag
        
        var change = 0
        if buttonTitle == "+" {
            change = 1
        } else if buttonTitle == "-" {
            change = -1
        } else if buttonTitle == "+5" {
            change = 5
        } else if buttonTitle == "-5" {
            change = -5
        }
        
        if player == 1 {
            lifeTotalPlayer1 += change
            player1LifeLabel.text = "Player 1: \(lifeTotalPlayer1)"
            checkForLoss(player: 1, lifeTotal: lifeTotalPlayer1)
        } else if player == 2 {
            lifeTotalPlayer2 += change
            player2LifeLabel.text = "Player 2: \(lifeTotalPlayer2)"
            checkForLoss(player: 2, lifeTotal: lifeTotalPlayer2)
        }
    }
    
    private func checkForLoss(player: Int, lifeTotal: Int) {
        if lifeTotal <= 0 {
            statusLabel.text = "Player \(player) LOSES!"
            statusLabel.isHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if view.bounds.width > view.bounds.height {
            parentStackView.axis = .horizontal
        } else {
            parentStackView.axis = .vertical
            parentStackView.spacing = 0
        }
    }
}

