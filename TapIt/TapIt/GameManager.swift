//
//  GameManager.swift
//  TapIt
//
//  Created by Erik Wurman on 11/30/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import Foundation

class GameManager {
    
    private var didTap = false
    private var didRotate = false
    private var didShake = false
    var currentGameActionNum: Int?
    
    enum Actions {
        case Tap
        case Rotate
        case Shake
    }
    
    private var gameActions: Dictionary<Int, Actions> = [
        1: Actions.Tap,
        2: Actions.Rotate,
        3: Actions.Shake
    ]
    
    private var gameActionStrings: Dictionary<Int, String> = [
        1: "Tap it",
        2: "Rotate it",
        3: "Shake it"
    ]

    
    func recieveData(didTap wasTapped: Bool, didRotate wasRotated: Bool, didShake wasShook : Bool){
        didTap = wasTapped
        didRotate = wasRotated
        didShake = wasShook
    }
    
    func getInstructionString() -> String{
        if currentGameActionNum != nil{
            return gameActionStrings[currentGameActionNum!]!
        }
        return "Tap to Begin"
    }
    
    func setNextRound() {
        resetData()
        currentGameActionNum = Int(arc4random_uniform(UInt32(gameActions.count))) + 1
        //get random number from 0 to the number of possible actions exclusive
        
    }
    
    private func resetData(){
        didTap = false
        didRotate = false
        didShake = false
    }
}
