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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationvc = segue.destination
        if let gamevc = destinationvc as? GameViewController {
            if segue.identifier == "Single Player" {
                gamevc.numPlayers = 1
                gamevc.setGameMode(mode: 0)
            } else if segue.identifier == "Multiplayer"{ //TODO: leftover code. never occurs
                gamevc.numPlayers = 3
                gamevc.setGameMode(mode: 1)
            } else {
                gamevc.numPlayers = 1
                gamevc.setGameMode(mode: 2) 

            }
            
            for i in 0 ..< gamevc.numPlayers! {
                let p = Player()
                p.name = "Player \(i + 1)"
                gamevc.playersArray.append(p)
            }

        }
    }



}

