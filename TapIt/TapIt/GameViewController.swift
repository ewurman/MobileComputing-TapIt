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
            //Add the swipe gesture recognizers to the playerManager
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: playerManager, action: #selector(playerManager.swipeUp))
            swipeUpRecognizer.direction = .up
            gameView.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: playerManager, action: #selector(playerManager.swipeDown))
            swipeDownRecognizer.direction = .down
            gameView.addGestureRecognizer(swipeDownRecognizer)

            let swipeLeftRecognizer = UISwipeGestureRecognizer(target: playerManager, action: #selector(playerManager.swipeLeft))
            swipeLeftRecognizer.direction = .left
            gameView.addGestureRecognizer(swipeLeftRecognizer)

            let swipeRightRecognizer = UISwipeGestureRecognizer(target: playerManager, action: #selector(playerManager.swipeRight))
            swipeRightRecognizer.direction = .right
            gameView.addGestureRecognizer(swipeRightRecognizer)

        }
    }
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var replayButton: UIButton!
    
    
    private var hasStarted = false
    private var tapped = false
    private var rotated = false
    private var shook = false
    private var gameMode = 0
    private var highScoreManager = HighScoreManager()
    
    private var hasLost : Bool {
        get {
         return playerManager.manager!.didLose
        }
    }
    
    private let maxSpeed = 1.0
    private var speed = 3.0
    private let roundDuration = 2.0
    private let roundLength = 3 //Maybe 4-6 range for actual game? 3 for Demo Purposes
    
    var gameTimer: Timer?

    let playerManager = PlayerManager()
    
    //called for replay
    private func resetPlayerArray(){
        playerManager.resetPlayerArray()
        setScoreLabel()
        setPlayerLabel()
    }
    
    //used when user wants to replay a game
    private func resetGame(){
        resetPlayerArray()
        hasStarted = false
        if gameMode == 2{
            speed = 1.5
        }else{
            speed = 3.0
        }
    }
    
    @IBAction func replayGame(_ sender: UIButton) {
        resetGame()
        setInstruction(labelText: "Tap Anywhere to Begin")
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        if !hasStarted{
            beginGame()
        }
        else{
            tapped = true
        }
    }

    
    @IBAction func redButton(_ sender: UIButton) {
        playerManager.manager?.tappedRed()
    }
    
    @IBAction func blueButton(_ sender: UIButton) {
        playerManager.manager?.tappedBlue()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            playerManager.manager?.shake()
        }
    }
    
    func disableReplayButton(){
        replayButton.isEnabled = false
        replayButton.alpha = 0.5
    }
    
    func enableReplayButton(){
        replayButton.isEnabled = true
        replayButton.alpha = 1.0
    }
    
    
    func setGameMode(mode: Int){
        gameMode = mode
        if (mode == 2) { //Frenzy is faster
            speed = speed / 2
        }
    }
    
    //function for rotate handling as a move in the game
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playerManager.manager?.rotate()
    }
    
    
    func beginGame(){
        playerManager.manager?.setNextTurn()
        setInstruction(labelText: (playerManager.manager?.getInstructionString())!)
        fadeInstructionOut(duration: speed)
        hasStarted = true
        newGameTimer()
        disableReplayButton()
    }
    
    func newGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(runGameCycle), userInfo: nil, repeats: true)
    }
    

    //gets from the player Manager whether it is the next round or the game is over.
    //Gets called when a round is over or someone loses
    func nextPlayer() {
        var isNewRound = false //checks if the next player is starting a new round
        var isGameOver = false //checks if all players have lost
        (isNewRound, isGameOver) = playerManager.nextPlayer()
        
        if isGameOver {
            print("Game Over")
            let winner = getWinner()
            if (gameMode == 1){
                setInstruction(labelText: "WINNER IS: \(winner.name)")
            }
            gameTimer?.invalidate()
            enableReplayButton()
        } else {
            var str = ""
            if isNewRound {
                speed = max(0.85 * speed, maxSpeed) //doesn't get faster than speed maxSpeed, which should be 1
                str = "R O U N D  \(playerManager.manager!.getRound())"
            } else {
                str = "Pass to \(playerManager.getPlayerName())"
            }
            
            gameTimer?.invalidate()
            setInstruction(labelText: str)
            fadeInstructionOut(duration: roundDuration)
            if #available(iOS 10.0, *) {
                //wait for fade then begin new round again
                gameTimer = Timer.scheduledTimer(withTimeInterval: roundDuration, repeats: false, block: {_ in
                    self.playerManager.manager?.setNextTurn()
                    self.setInstruction(labelText: self.playerManager.manager!.getInstructionString())
                    self.fadeInstructionOut(duration: self.speed)
                    self.newGameTimer()
                })
            } else {
                // Fallback on earlier versions. We do not support earlier versions
            }
            setPlayerLabel()
            setScoreLabel()
   
        }

    }
    
    // this is the action function that our timer 
    // it uses that deals with the user response to a prompt and gets the next round
    func runGameCycle(){
        if hasStarted{
            playerManager.manager?.nextTurn()
            let score = playerManager.manager!.getScore()
            
            if hasLost {
                print("\(playerManager.getPlayerName()) has lost!!")
                gameTimer?.invalidate()
                setInstruction(labelText: "\(playerManager.getPlayerName()) has lost!!")
                fadeInstructionOut(duration: Double(roundLength))
                if #available(iOS 10.0, *) {
                    gameTimer = Timer.scheduledTimer(withTimeInterval: roundDuration, repeats: false, block: {_ in
                        self.nextPlayer()
                    })
                } else {
                    // Fallback on earlier versions. Not supported in our app
                }
 
            } else if score % roundLength == 0 && score != 0 { //if end of round
                
                if gameMode == 2{ //frenzy doesn't have a break for each round
                    speed = max(speed * 0.85, maxSpeed) //never pass speed maxSpeed, should be 1
                    playerManager.manager?.nextRound()
                    playerManager.manager?.setNextTurn()
                    setScoreLabel()
                    setInstruction(labelText: (playerManager.manager?.getInstructionString())!)
                    fadeInstructionOut(duration: speed)
                } else{
                    nextPlayer()
                }
                
            } else { //not a next round, player gets next instruction
                playerManager.manager?.setNextTurn()
                setScoreLabel()
                setInstruction(labelText: (playerManager.manager?.getInstructionString())!)
                fadeInstructionOut(duration: speed)
            }
            
        }

    }
    
    func setHighScoreLabel(){
        highScoreLabel.text = "HighScore: \(highScoreManager.readGameModesHighScore(gameMode: gameMode))"
    }
    
    func setScoreLabel() {
        scoreLabel.alpha = 1.0
        if let m = playerManager.manager {
            let score = m.getScore()
            scoreLabel.text = "Score: \(score)"
            highScoreManager.updateHighScoreFor(gameMode: gameMode, highScore: score)
            //updates high score if you pass it
            setHighScoreLabel()
        }
    }
    
    //messes with colors if at a high round tap red might be in blue
    func setInstruction(labelText: String){
        var color = UIColor.white
        if let round = playerManager.manager?.getRound() {
            if labelText == "Tap red" {
                color = round < 2 ? UIColor.red : redOrBlue()
            }
            if labelText == "Tap blue" {
                color = round < 2 ? UIColor(red: 0/255, green: 177/255, blue: 247/255, alpha: 1.0) : redOrBlue()
            }
        }
        
        instructionLabel.textColor = color
        instructionLabel.alpha = 1.0
        instructionLabel.text = labelText
    }
    
    func redOrBlue() -> UIColor {
        let colors = [UIColor.red, UIColor(red: 0/255, green: 177/255, blue: 247/255, alpha: 1.0)]
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }
    
    func setPlayerLabel() {
        playerLabel.alpha = 1.0
        playerLabel.text = playerManager.getPlayerName()
    }
    
    func fadeInstructionOut(duration: Double){
        instructionLabel.fadeOut(fadeDuration: duration * 0.75, delayDuration: duration * 0.25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        setHighScoreLabel()
        setNavTitle()
        setPlayerLabel()
    }
    
    private func setNavTitle(){
        //navigationItem.titleView.colo
        switch gameMode {
        case 0:
            navigationItem.title = "Single Player Mode"
        case 1:
            navigationItem.title = "\(playerManager.numPlayers) Player Mode"
        default:
            navigationItem.title = "Frenzy Mode"
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getWinner() -> Player {
        return playerManager.getWinner()
    }


}
