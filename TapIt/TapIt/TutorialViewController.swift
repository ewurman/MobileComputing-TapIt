//
//  TutorialViewController.swift
//  TapIt
//
//  Created by Erik Wurman on 12/14/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    private var hasBegun = false
    private var manager = TutorialManager()
    private var gameTimer: Timer?
    private var speed = 3.0
    private var hasLost : Bool {
        get {
            return manager.didLose
        }
    }
    private var hasWon : Bool {
        get {
            return manager.didWin
        }
    }
    
    @IBOutlet weak var tutorialView: UIView!{
        didSet{
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeUp))
            swipeUpRecognizer.direction = .up
            tutorialView.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeDown))
            swipeDownRecognizer.direction = .down
            tutorialView.addGestureRecognizer(swipeDownRecognizer)
            
            let swipeLeftRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeLeft))
            swipeLeftRecognizer.direction = .left
            tutorialView.addGestureRecognizer(swipeLeftRecognizer)
            
            let swipeRightRecognizer = UISwipeGestureRecognizer(target: manager, action: #selector(manager.swipeRight))
            swipeRightRecognizer.direction = .right
            tutorialView.addGestureRecognizer(swipeRightRecognizer)
        }
    }
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        if !hasBegun{
            begin(at: 1)
        }
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        manager.tappedBlue()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
            manager.shake()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        manager.rotate()
    }
    
    private func newGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(runGameCycle), userInfo: nil, repeats: true)
    }
    
    private func begin(at: Int){
        manager.currentGameActionNum = at
        manager.setNextTurn()   //start at tapBlue
        setInstruction(labelText: (manager.getInstructionString()))
        fadeInstructionOut(duration: speed)
        hasBegun = true
        newGameTimer()
    }
    
    @objc private func runGameCycle(){
        if hasBegun{
            manager.nextTurn()
            if hasLost{
                //Tell them they got it wrong then retry the same command
                
                gameTimer?.invalidate()
                setInstruction(labelText: "Try again.")
                fadeInstructionOut(duration: speed / 2)
                if #available(iOS 10.0, *) {
                    gameTimer = Timer.scheduledTimer(withTimeInterval: speed / 2, repeats: false, block: {_ in
                        self.manager.didLose = false
                        self.begin(at: self.manager.currentGameActionNum! - 1) //go back to this action
                    })
                } else {
                    // Fallback on earlier versions. We don't support earlier versions
                }
            }else {
                manager.setNextTurn()
                if hasWon{
                    gameTimer?.invalidate()
                    setInstruction(labelText: "You have completed the tutorial!")
                    hasBegun = false
                }
                else{
                    setInstruction(labelText: manager.getInstructionString())
                    fadeInstructionOut(duration: speed)
                }
            }
            
        }
    }
    
    func setInstruction(labelText: String){
        instructionLabel.alpha = 1.0
        instructionLabel.text = labelText
    }
    
    func fadeInstructionOut(duration: Double){
        instructionLabel.fadeOut(fadeDuration: duration * 0.75, delayDuration: duration * 0.25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
