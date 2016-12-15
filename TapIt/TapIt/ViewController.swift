//
//  ViewController.swift
//  TapIt
//
//  Created by Erik Wurman on 11/7/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import UIKit
import Foundation

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationvc = segue.destination
        if let gamevc = destinationvc as? GameViewController {
            if segue.identifier == "Single Player" {
                gamevc.playerManager.numPlayers = 1
                gamevc.setGameMode(mode: 0)
            } else { //Frenzy Mode
                gamevc.playerManager.numPlayers = 1
                gamevc.setGameMode(mode: 2)
            }
            //Multiplayer done in the multiplayerViewController as it has a menu
            gamevc.playerManager.initializePlayersArray()

        }
    }



}

