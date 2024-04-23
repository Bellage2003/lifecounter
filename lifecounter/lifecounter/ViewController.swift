//
//  ViewController.swift
//  lifecounter
//
//  Created by Bella Ge on 2024/4/14.
//

import UIKit

struct Player {
    var lifeTotal: Int = 20
    var lifeLabel: UILabel
}

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var removePlayerButton: UIButton!
    
    var players: [Player] = []
    var gameStarted = false
    var gameHistory: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for playerNumber in 1...4 {
            addPlayer(playerNumber: playerNumber)
        }
        statusLabel.isHidden = true
        okButton.isHidden = true
        updateRemovePlayerButtonState()
        setupTextFields()
    }
    
    func setupTextFields() {
        for tag in 101...803 {
            if let textField = view.viewWithTag(tag) as? UITextField {
                textField.delegate = self
                textField.keyboardType = .numberPad
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return string.isEmpty || allowedCharacters.isSuperset(of: characterSet)
    }
    
    @IBAction func historyButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showHistorySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistorySegue",
           let historyVC = segue.destination as? HistoryViewController {
            historyVC.historyData = self.gameHistory
        }
    }
    
    @IBAction func addPlayerButtonTapped(_ sender: UIButton) {
        if players.count < 8 {
            addPlayer(playerNumber: players.count + 1)
        }
        addPlayerButton.isEnabled = players.count < 8
    }
    
    func addPlayer(playerNumber: Int) {
        let playerLabel = UILabel()
        playerLabel.text = "Player \(playerNumber): 20"
        playerLabel.textAlignment = .center
            
        let addButton = UIButton(type: .system)
        addButton.setTitle("+", for: .normal)
        addButton.tag = playerNumber * 10 + 1
        addButton.addTarget(self, action: #selector(chooseAction), for: .touchUpInside)
            
        let subtractButton = UIButton(type: .system)
        subtractButton.setTitle("-", for: .normal)
        subtractButton.tag = playerNumber * 10 + 2
        subtractButton.addTarget(self, action: #selector(chooseAction), for: .touchUpInside)
            
        let addLifeTextField = UITextField()
        addLifeTextField.delegate = self
        addLifeTextField.keyboardType = .numberPad
        addLifeTextField.tag = playerNumber * 100 + 1
        addLifeTextField.layer.borderColor = UIColor.systemBlue.cgColor
        addLifeTextField.layer.borderWidth = 1.0
        addLifeTextField.layer.cornerRadius = 5.0
            
        let subtractLifeTextField = UITextField()
        subtractLifeTextField.delegate = self
        subtractLifeTextField.keyboardType = .numberPad
        subtractLifeTextField.tag = playerNumber * 100 + 2
        subtractLifeTextField.layer.borderColor = UIColor.systemBlue.cgColor
        subtractLifeTextField.layer.borderWidth = 1.0
        subtractLifeTextField.layer.cornerRadius = 5.0
        
        let addStackView = UIStackView(arrangedSubviews: [addButton, addLifeTextField])
        addStackView.axis = .horizontal
        addStackView.distribution = .fillEqually
        
        let subtractStackView = UIStackView(arrangedSubviews: [subtractButton, subtractLifeTextField])
        subtractStackView.axis = .horizontal
        subtractStackView.distribution = .fillEqually

        let playerStackView = UIStackView(arrangedSubviews: [playerLabel, addStackView, subtractStackView])
        playerStackView.axis = .horizontal
        playerStackView.distribution = .fillEqually
        playerStackView.alignment = .fill
        playerStackView.spacing = 3
        
        parentStackView.addArrangedSubview(playerStackView)
        players.append(Player(lifeTotal: 20, lifeLabel: playerLabel))
        updateRemovePlayerButtonState()
    }
    
    
    @IBAction func chooseAction(_ sender: UIButton) {
        let playerIndex = sender.tag / 10 - 1
        let isAddition = sender.tag % 10 == 1
        let textFieldTag = (playerIndex + 1) * 100 + (isAddition ? 1 : 2)
        
        guard let textField = self.view.viewWithTag(textFieldTag) as? UITextField,
              let changeText = textField.text,
              let changeAmount = Int(changeText),
              !changeText.isEmpty else {
            return
        }
        
        let change = isAddition ? changeAmount : -changeAmount
        adjustLifeTotal(for: playerIndex, change: change)
        let actionDescription = isAddition ? "gained" : "lost"
        gameHistory.append("Player \(playerIndex + 1) \(actionDescription) \(abs(change)) life.")
    }
    
    private func adjustLifeTotal(for playerIndex: Int, change: Int) {
        if !gameStarted && change != 0 {
            gameStarted = true
            addPlayerButton.isEnabled = false
        }
        
        if players.indices.contains(playerIndex) {
            players[playerIndex].lifeTotal += change
            players[playerIndex].lifeLabel.text = "Player \(playerIndex + 1): \(players[playerIndex].lifeTotal)"
            
            checkForLoss(playerIndex: playerIndex)
        }
    }


    private func checkForLoss(playerIndex: Int) {
        let player = players[playerIndex]
        if player.lifeTotal <= 0 {
            statusLabel.text = "Player \(playerIndex + 1) LOSES! Game Over!"
            statusLabel.isHidden = false
            okButton.isHidden = false
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetGame()
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        resetGame()
    }
    
    private func resetGame() {
        for index in players.indices {
            players[index].lifeTotal = 20
            players[index].lifeLabel.text = "Player \(index + 1): 20"
        }
        gameStarted = false
        addPlayerButton.isEnabled = true
        historyButton.isEnabled = true
        statusLabel.isHidden = true
        okButton.isHidden = true
        gameHistory.removeAll()
        
        for playerNumber in 1...players.count {
            if let addTextField = self.view.viewWithTag(playerNumber * 100 + 1) as? UITextField {
                addTextField.text = ""
            }
            if let subtractTextField = self.view.viewWithTag(playerNumber * 100 + 2) as? UITextField {
                subtractTextField.text = ""
            }
        }
    }
    
    @IBAction func removePlayerButtonTapped(_ sender: UIButton) {
        guard players.count > 2 else { return }
        let playerToRemove = players.removeLast()
        if let playerStackView = playerToRemove.lifeLabel.superview as? UIStackView {
            playerStackView.removeFromSuperview()
        }
        updateRemovePlayerButtonState()
    }
    
    func updateRemovePlayerButtonState() {
        removePlayerButton.isEnabled = players.count > 2
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if view.bounds.width > view.bounds.height {
            parentStackView.axis = .vertical
        } else {
            parentStackView.axis = .vertical
            parentStackView.spacing = 0
        }
    }
}



