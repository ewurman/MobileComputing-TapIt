//
//  TutorialManager.swift
//  TapIt
//
//  Created by Erik Wurman on 12/14/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import Foundation

class TutorialManager: GameManager{
    var didWin = false
    
    override func setNextTurn() {
        resetData()
        currentGameActionNum = currentGameActionNum! + 1
        if currentGameActionNum! > GameManager.numberOfActions{
            didWin = true
        }
    }
    
    
}
