//
//  GameManager.swift
//  TapIt
//
//  Created by Erik Wurman on 11/30/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import Foundation

class GameManager {
    
    private var score = 0
    func getScore() -> Int { return score }
    
    private var round = 1
    func getRound() -> Int { return round }
    func nextRound() { round += 1 }
    
    //bool checks, representing what action was done by user
    private var didTap = false
    private var didTapRed = false
    private var didTapBlue = false
    private var didRotate = false
    private var didShake = false
    private var didSwipeLeft = false
    private var didSwipeRight = false
    private var didSwipeUp = false
    private var didSwipeDown = false

    
    //functions to change bool checks from controller
    func tappedRed() { didTapRed = true }
    func tappedBlue() { didTapBlue = true }
    @objc func swipeLeft() { didSwipeLeft = true }
    @objc func swipeRight() { didSwipeRight = true }
    @objc func swipeUp() { didSwipeUp = true }
    @objc func swipeDown() { didSwipeDown = true }
    func shake() { didShake = true }
    func rotate() { didRotate = true }
    
    var didLose = false
    var currentGameActionNum: Int?
    
    enum Actions: Int {
        case Tap_Red = 1
        case Tap_Blue
        case Swipe_Up
        case Swipe_Down
        case Swipe_Left
        case Swipe_Right
        case Shake
        case Rotate
    }
    
    //get numberOfActions
    static let numberOfActions: Int = {
        var max: Int = 1
        while let _ = Actions(rawValue: max) { max += 1 }
        return (max - 1)
    }()
    

    private var gameActionStrings: Dictionary<Int, String> = [
        1: "Tap red",
        2: "Tap blue",
        3: "Swipe Up",
        4: "Swipe Down",
        5: "Swipe Left",
        6: "Swipe Right",
        7: "Shake It!",
        8: "Rotate it",
    ]

    
    func getInstructionString() -> String{
        if currentGameActionNum != nil{
            return gameActionStrings[currentGameActionNum!]!
        }
        return "Tap to Begin"
    }

    func setNextTurn() {
        resetData()
        //get random number from 1 to the number of possible actions exclusive
        currentGameActionNum = Int(arc4random_uniform(UInt32(GameManager.numberOfActions))) + 1
    }
    
    func nextTurn() {
        if let action = Actions(rawValue: currentGameActionNum!) {
            
            switch action {
            case .Tap_Red:
                if !checkExlusive(check: &didTapRed) { didLose = true }
                
            case .Tap_Blue:
                if !checkExlusive(check: &didTapBlue) { didLose = true }
                
            case .Swipe_Up:
                if !checkExlusive(check: &didSwipeUp) { didLose = true }

            case .Swipe_Down:
                if !checkExlusive(check: &didSwipeDown) { didLose = true }

            case .Swipe_Left:
                if !checkExlusive(check: &didSwipeLeft) { didLose = true }
                
            case .Swipe_Right:
                if !checkExlusive(check: &didSwipeRight) { didLose = true }
                
            case .Shake:
                if !checkExlusive(check: &didShake) { didLose = true }
            
            case .Rotate:
                if !checkExlusive(check: &didRotate) { didLose = true }
               
            }
        }
        if !didLose { score += 1 }
    }
    
    //we want to check if the given check is true, and only that check is true
    //make the given check false, and check that all the checks are false
    //passed as pointer, so check is sent back to false after the function exits
    private func checkExlusive(check: inout Bool) -> Bool {
        if (!check) {
            return false
        } else {
            check = false
            return allChecksFalse()
        }
    }
    
    
    private func allChecksFalse() -> Bool {
        return (
            didTap == false &&
            didTapRed ==  false &&
            didTapBlue == false &&
            didRotate == false &&
            didShake == false &&
            didSwipeLeft == false &&
            didSwipeRight == false &&
            didSwipeUp == false &&
            didSwipeDown == false
        )
    }
    
    func resetData(){
        //TODO: keep adding all new variables here
        didTap = false
        didTapRed = false
        didTapBlue = false
        didRotate = false
        didShake = false
        didSwipeLeft = false
        didSwipeRight = false
        didSwipeUp = false
        didSwipeDown = false
    }
}
