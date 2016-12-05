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
    
    private var hasStarted = false
    private var tapped = false
    private var rotated = false
    private var shook = false
    
    private var hasLost : Bool {
        get {
         return manager.didLose
        }
    }
    
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
        manager.setNextRound()
        setInstruction(labelText: manager.getInstructionString())
        fadeInstructionOut()
        hasStarted = true
        gameTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(runGameCycle), userInfo: nil, repeats: true)
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
            
            manager.setNextRound()
            setInstruction(labelText: manager.getInstructionString())
            fadeInstructionOut()

            
            
            /* Get the desired action from model.
             * Set label in view to desired action
             * wait timeInterval then pass values to model to check if correct action occured
             * update hasLost
             */
            
        }

    }
    
    func setInstruction(labelText: String){
        instructionLabel.alpha = 1.0
        instructionLabel.text = labelText
    }
    
    func fadeInstructionOut(){
        //TODO: make the time interval a variable
        instructionLabel.fadeOut(fadeDuration: 2.0, delayDuration: 1.0)
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
