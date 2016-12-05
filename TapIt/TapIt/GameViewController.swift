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

            let swipeUpRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeUp))
            swipeUpRecognizer.direction = .up
            gameView.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeDown))
            swipeDownRecognizer.direction = .down
            gameView.addGestureRecognizer(swipeDownRecognizer)

            let swipeLeftRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeLeft))
            swipeLeftRecognizer.direction = .left
            gameView.addGestureRecognizer(swipeLeftRecognizer)

            let swipeRightRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeRight))
            swipeRightRecognizer.direction = .right
            gameView.addGestureRecognizer(swipeRightRecognizer)

            
          /*
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            */
            //gameView.dataSource = self
            //updateUI()
        }
    }
    
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    private var hasStarted = false
    private var tapped = false
    private var rotated = false
    private var shook = false
    
    private var hasLost : Bool {
        get {
         return manager.didLose
        }
    }
    
    private var speed = 3.0
    private let roundDuration = 2.0
    private let roundLength = 3
    
    var gameTimer: Timer?
    
    let manager = GameManager()
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        if !hasStarted{
            beginGame()
        }
        else{
            tapped = true
        }
    }

    
    @IBAction func redButton(_ sender: UIButton) {
        manager.tappedRed()
    }
    
    @IBAction func blueButton(_ sender: UIButton) {
        manager.tappedBlue()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            manager.shake()
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        manager.rotate()
        /*
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
         */
    }
    
 
    func beginGame(){
        manager.setNextTurn()
        setInstruction(labelText: manager.getInstructionString())
        fadeInstructionOut(duration: speed)
        hasStarted = true
        newGameTimer()

    }
    
    func newGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(runGameCycle), userInfo: nil, repeats: true)
    }
    
    func resetGame(){
        hasStarted = false
        gameTimer?.invalidate()
    }
    
    func runGameCycle(){
        if hasStarted{
            manager.nextTurn()
            if hasLost{
                print("you lose!!")
                resetGame()
                return
            }
            
            manager.setNextTurn()
            setScoreLabel()
            setInstruction(labelText: manager.getInstructionString())
            fadeInstructionOut(duration: speed)
            
            
            let score = manager.getScore()
            if score % roundLength == 0 && score != 0 {
                manager.nextRound()
                speed -= 0.5
                gameTimer?.invalidate()
                setInstruction(labelText: "R O U N D  \(manager.getRound())")
                fadeInstructionOut(duration: roundDuration)
                if #available(iOS 10.0, *) {
                    gameTimer = Timer.scheduledTimer(withTimeInterval: roundDuration, repeats: false, block: {_ in
                        self.manager.setNextTurn()
                        self.setInstruction(labelText: self.manager.getInstructionString())
                        self.fadeInstructionOut(duration: self.speed)
                        self.newGameTimer()
                    })
                } else {
                    // Fallback on earlier versions
                }
                
                
            }

            
            
            /* Get the desired action from model.
             * Set label in view to desired action
             * wait timeInterval then pass values to model to check if correct action occured
             * update hasLost
             */
            
        }

    }
    
    func setScoreLabel() {
        scoreLabel.alpha = 1.0
        scoreLabel.text = String( manager.getScore() )
    }
    
    func setInstruction(labelText: String){
        instructionLabel.alpha = 1.0
        instructionLabel.text = labelText
    }
    
    func fadeInstructionOut(duration: Double){
        //TODO: make the time interval a variable
        instructionLabel.fadeOut(fadeDuration: duration * 0.75, delayDuration: duration * 0.25)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
    }
    

    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
