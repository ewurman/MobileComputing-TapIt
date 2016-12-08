//
//  GameViewController.swift
//  TapIt
//
//  Created by Erik Wurman on 11/30/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: UIView! {
        didSet {

            let swipeUpRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager?.swipeUp))
            swipeUpRecognizer.direction = .up
            gameView.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager?.swipeDown))
            swipeDownRecognizer.direction = .down
            gameView.addGestureRecognizer(swipeDownRecognizer)

            let swipeLeftRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager?.swipeLeft))
            swipeLeftRecognizer.direction = .left
            gameView.addGestureRecognizer(swipeLeftRecognizer)

            let swipeRightRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager?.swipeRight))
            swipeRightRecognizer.direction = .right
            gameView.addGestureRecognizer(swipeRightRecognizer)

        }
    }
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var playerLabel: UILabel!
    
    private var hasStarted = false
    private var tapped = false
    private var rotated = false
    private var shook = false
    private var gameMode = 1
    private var highScoreManager = HighScoreManager()
    
    private var hasLost : Bool {
        get {
         return manager!.didLose
        }
    }
    
    private var speed = 2.0
    private let roundDuration = 2.0
    private let roundLength = 3
    
    var gameTimer: Timer?
    
    var numPlayers: Int?
    var playersArray = [Player]() {
        didSet {
            manager = playersArray[playerPointer].manager
        }
    }
    var playerPointer = 0
    
    var manager: GameManager?

    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        if !hasStarted{
            beginGame()
        }
        else{
            tapped = true
        }
    }

    
    @IBAction func redButton(_ sender: UIButton) {
        manager?.tappedRed()
    }
    
    @IBAction func blueButton(_ sender: UIButton) {
        manager?.tappedBlue()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            manager?.shake()
        }
    }
    
    func setGameMode(mode: Int){
        gameMode = mode
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        manager?.rotate()
        /*
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
         */
    }
    
 
    func beginGame(){
        manager?.setNextTurn()
        setInstruction(labelText: (manager?.getInstructionString())!)
        fadeInstructionOut(duration: speed)
        hasStarted = true
        newGameTimer()

    }
    
    func newGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(runGameCycle), userInfo: nil, repeats: true)
    }
    

    func nextPlayer() {
        
        manager?.nextRound()

        var isNewRound = false //checks if the next player is starting a new round
        var isGameOver = false //checks if all players have lost
        playerPointer += 1
        
        //if the player pointer is beyond the array, its a new round
        if playerPointer >= playersArray.count {
            isNewRound = true
            playerPointer = 0
        }
        
        //do this loop until we find a player who hasn't lost already
        //ie, get next player who's still active
        while (playersArray[playerPointer].manager.didLose) {
            playerPointer += 1
            
            //if the player pointer is beyond array, its a new round
            if playerPointer >= playersArray.count {
                //if its already been found as a new round, nobody is left
                if isNewRound == true {
                    isGameOver = true
                    break
                }
                isNewRound = true
                playerPointer = 0
            }
        }
        
        if isGameOver {
            print("Game Over")
            let winner = getWinner()
            setInstruction(labelText: "WINNER IS: \(winner.name)")
            gameTimer?.invalidate()
        } else {
            var str = ""
            if isNewRound {
                speed -= 0.5
                str = "R O U N D  \(manager!.getRound())"
            } else {
                str = "Pass to \(playersArray[playerPointer].name)"
            }
            
            manager = playersArray[playerPointer].manager
            gameTimer?.invalidate()
            setInstruction(labelText: str)
            fadeInstructionOut(duration: roundDuration)
            if #available(iOS 10.0, *) {
                gameTimer = Timer.scheduledTimer(withTimeInterval: roundDuration, repeats: false, block: {_ in
                    self.manager?.setNextTurn()
                    self.setInstruction(labelText: self.manager!.getInstructionString())
                    self.fadeInstructionOut(duration: self.speed)
                    self.newGameTimer()
                })
            } else {
                // Fallback on earlier versions
            }
            setPlayerLabel()
            setScoreLabel()
   
        }

    }
    
    func runGameCycle(){
        if hasStarted{
            manager?.nextTurn()
            let score = manager!.getScore()
            
            if hasLost {
                print("\(playersArray[playerPointer].name) has lost!!")
                gameTimer?.invalidate()
                setInstruction(labelText: "\(playersArray[playerPointer].name) has lost!!")
                fadeInstructionOut(duration: Double(roundLength))
                if #available(iOS 10.0, *) {
                    gameTimer = Timer.scheduledTimer(withTimeInterval: roundDuration, repeats: false, block: {_ in
                        self.numPlayers! -= 1
                        self.nextPlayer()
                    })
                } else {
                    // Fallback on earlier versions
                }
 
            } else if score % roundLength == 0 && score != 0 {
                
                nextPlayer()
                
            } else {
                manager?.setNextTurn()
                setScoreLabel()
                setInstruction(labelText: (manager?.getInstructionString())!)
                fadeInstructionOut(duration: speed)
            }
            
        }

    }
    
    func setHighScoreLabel(){
        highScoreLabel.text = "HighScore: \(highScoreManager.readGameModesHighScore(gameMode: gameMode))"
    }
    
    func setScoreLabel() {
        scoreLabel.alpha = 1.0
        if let m = manager {
            let score = m.getScore()
            scoreLabel.text = "Score: \(score)"
            highScoreManager.updateHighScoreFor(gameMode: gameMode, highScore: score)
            setHighScoreLabel()
        }
    }
    
    func setInstruction(labelText: String){
        instructionLabel.alpha = 1.0
        instructionLabel.text = labelText
    }
    
    func setPlayerLabel() {
        playerLabel.alpha = 1.0
        playerLabel.text = playersArray[playerPointer].name
    }
    
    func fadeInstructionOut(duration: Double){
        instructionLabel.fadeOut(fadeDuration: duration * 0.75, delayDuration: duration * 0.25)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        setHighScoreLabel()
    }
    

    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWinner() -> Player {
        
        var winner = playersArray[0]
        var winningScore = playersArray[0].manager.getScore()
        for player in playersArray {
            if player.manager.getScore() > winningScore {
                winningScore = player.manager.getScore()
                winner = player
            }
        }
        return winner
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
