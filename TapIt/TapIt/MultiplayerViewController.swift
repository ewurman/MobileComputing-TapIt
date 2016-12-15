//
//  MultiplayerViewController.swift
//  TapIt
//
//  Created by Erik Wurman on 12/12/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import UIKit

class MultiplayerViewController: UIViewController {

    var numPlayers = 3
    private let minPlayers = 2
    private let maxPlayers = 10
    private let fadeOutTime = 0.25
    private let fadeInTime = 0.1
    
    var playerNames: [String]?
    
    @IBOutlet weak var numPlayersLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBAction func addPlayer(_ sender: UIButton) {
        playerNames = nil
        activateButton(button: removeButton)
        if numPlayers < maxPlayers{
            numPlayers += 1
            updateLabel()
        }
        if numPlayers == maxPlayers{
            inactivateButton(button: addButton)
        }
    }
    
    @IBAction func removePlayer(_ sender: UIButton) {
        playerNames = nil
        activateButton(button: addButton)
        if numPlayers > minPlayers{
            numPlayers -= 1
            updateLabel()
        }
        if numPlayers == minPlayers{
            inactivateButton(button: removeButton)
        }
    }
    
    private func updateLabel(){
        numPlayersLabel.fadeOut(fadeDuration: fadeOutTime, delayDuration: 0)
        numPlayersLabel.text = String(numPlayers)
        numPlayersLabel.fadeIn(fadeDuration: fadeInTime, delayDuration: fadeOutTime)
    }
    
    private func inactivateButton(button: UIButton){
        button.isEnabled = false
        button.alpha = 0.5
    }
    
    private func activateButton(button: UIButton){
        button.isEnabled = true
        button.alpha = 1
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if playerNames != nil {numPlayers = playerNames!.count}
        updateLabel()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationvc = segue.destination
        if let gamevc = destinationvc as? GameViewController {
            //gamevc.numPlayers = numPlayers
            gamevc.setGameMode(mode: 1)
            gamevc.playerManager.setNumPlayers(number: numPlayers)
            if (playerNames != nil) {gamevc.playerManager.playerNames = playerNames}
            gamevc.playerManager.initializePlayersArray()
            
            
//            for i in 0 ..< gamevc.numPlayers! {
//                let p = Player()
//                p.name = "Player \(i + 1)"
//                gamevc.playersArray.append(p)
//            }
        } else if let modalvc = destinationvc as? NamingViewController {
            modalvc.numPlayers = numPlayers
        }
    }
    

}
