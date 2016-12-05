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
    private var didTapRed = false
    private var didTapBlue = false
    private var didRotate = false
    private var didShake = false
    
    var didLose = false
    var currentGameActionNum: Int?
    
    enum Actions {
        case Tap_Red
        case Tap_Blue
        //case Rotate
        //case Shake
    }
    
    private var gameActions: Dictionary<Int, Actions> = [
        1: Actions.Tap_Red,
        2: Actions.Tap_Blue,
        //3: Actions.Rotate,
        //4: Actions.Shake
    ]
    
    private var gameActionStrings: Dictionary<Int, String> = [
        1: "Tap red",
        2: "Tap blue",
        //3: "Rotate it",
        //4: "Shake it"
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
        //get random number from 1 to the number of possible actions exclusive
        
    }
    
    func nextTurn() {
        if let action = gameActions[currentGameActionNum!] {
            switch action {
            case .Tap_Red:
                if check_tap_red() {
                    didTapRed = false
                    didTapBlue = false
                } else { didLose = true }
            case .Tap_Blue:
                if check_tap_blue() {
                    didTapRed = false
                    didTapBlue = false
                } else { didLose = true }
                /*
            case .Rotate:
                break
            case .Shake:
                break
                */
            }
        }
    }
    
    private func check_tap_red() -> Bool{
        return (didTapRed && !didTapBlue)
    }
    
    private func check_tap_blue() -> Bool{
        return (didTapBlue && !didTapRed)
    }
    
    func tappedRed() {
        didTapRed = true
    }
    
    func tappedBlue() {
        didTapBlue = true
    }
    
    private func resetData(){
        didTap = false
        didRotate = false
        didShake = false
    }
}
