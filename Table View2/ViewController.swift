 //
//  ViewController.swift
//  Table View2
//
//  Created by Диас Акберген on 08.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameTimer: UILabel!
    
    
    @IBOutlet weak var gameMoves: UILabel!
    
    var images  = ["1", "2", "3", "4", "5", "6", "7", "8", "1", "2", "3", "4", "5", "6", "7", "8"]
    
    var cardStates = [Int](repeating: 0, count: 16) // Tracks card states: 0 = face down, 1 = flipped, 2 = matched
        var winState = [[Int]]()
    
    var isActive = false
    
    var timer = Timer()
    var secondsPassed = 0
    
    var moves = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        images.shuffle()
        generateWinState()
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    func startTimer () {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        secondsPassed += 1
        gameTimer.text = formatTimer(secondsPassed)
    }
    
    func stopTimer () {
        timer.invalidate()
    }
    
    func formatTimer(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secondsPart = seconds % 60
        return String(format: "%02d:%02d", minutes, secondsPart)
    }
    
    
    func generateWinState() {
            var indexMap = [String: [Int]]()
        
            for (index, imageName) in images.enumerated() {
                if indexMap[imageName] != nil {
                    indexMap[imageName]!.append(index)
                } else {
                    indexMap[imageName] = [index]
                }
            }
            
            winState = indexMap.values.map { [$0[0], $0[1]] }
        }
    
    func checkWin() {
        if cardStates.allSatisfy({ $0 == 2 }){
            stopTimer()
            let alert = UIAlertController(title: "You win", message: "Choose an option", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            alert.addAction(UIAlertAction(title: "Play again", style: .default, handler: { _ in
                self.replayGame()
            }))
            present(alert, animated: true)
        }
    }
    
    func replayGame() {
        stopTimer()
        secondsPassed = 0
        
        moves = 0
        gameMoves.text = "Moves: \(moves)"
        
        cardStates = [Int](repeating: 0, count: 16)
        
        images.shuffle()
        
        generateWinState()
        
        for i in 0..<cardStates.count {
            if let button = self.view.viewWithTag(i + 1) as? UIButton {
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemGreen
            }
        }
            
            startTimer()
            
    }
    
    @IBAction func handleCardTap(_ sender: UIButton) {
        print(sender.tag)
        
        if cardStates[sender.tag - 1] != 0 || isActive {
            return
        }
        
        sender.setBackgroundImage(UIImage(named: images[sender.tag - 1]), for: .normal)
        
        cardStates[sender.tag - 1] = 1
        
        moves += 1
        gameMoves.text = "Moves: \(moves)"
        
        var count = 0
        for item in cardStates {
            if item == 1 {
                count += 1
            }
        }
        
        if count == 2 {
            isActive = true
            for winArray in winState {
                if cardStates[winArray[0]] == cardStates[winArray[1]] && cardStates[winArray[1]] == 1{
                    cardStates[winArray[0]] = 2
                    cardStates[winArray[1]] = 2
                    isActive = false
                }
            }
            if isActive {
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clear), userInfo: nil, repeats: false)
            } else{
                checkWin()
            }
        }
    }
        @objc func clear() {
            for i in 0..<cardStates.count {
                if cardStates[i] == 1{
                    cardStates[i] = 0
                    let button = self.view.viewWithTag(i + 1) as! UIButton
                    button.setBackgroundImage(nil, for: .normal)
                    button.backgroundColor = UIColor.systemGreen
                }
            }
            isActive = false
        }
        
        
    }

