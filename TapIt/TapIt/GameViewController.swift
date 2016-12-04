//
//  GameViewController.swift
//  TapIt
//
//  Created by Erik Wurman on 11/30/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    private var hasStarted = false
    private var hasLost = false
    private var tapped = false
    private var rotated = false
    private var shook = false
    
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
    
    
    
    func beginGame(){
        hasStarted = true
        gameTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(runGameCycle), userInfo: nil, repeats: true)
    }
    
    func resetGame(){
        hasStarted = false
        hasLost = false
        gameTimer?.invalidate()
    }
    
    func runGameCycle(){
        if hasStarted{
            /* Get the desired action from model.
             * Set label in view to desired action
             * wait timeInterval then pass values to model to check if correct action occured
             * update hasLost
             */
            manager.setNextRound()
            
        }
        if hasLost{
            resetGame()
        }
    }
    
    func setInstruction(labelText: String){
        instructionLabel.text = labelText
    }
    
    func fadeInstruction(){
        //TODO: all of this
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
