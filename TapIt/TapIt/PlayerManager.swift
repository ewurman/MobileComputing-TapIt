//
//  File.swift
//  TapIt
//
//  Created by Erik Wurman on 12/14/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import Foundation

class PlayerManager {
    
    var playersArray = [Player]()
    var numPlayers = 1
    
    var playerPointer = 0
    var manager: GameManager?
    
    func initializePlayersArray() {
        for i in 0 ..< numPlayers {
            let p = Player()
            p.name = "Player \(i + 1)"
            playersArray.append(p)
        }
        manager = playersArray[0].manager
    }
    
    func setNumPlayers(number: Int){
        numPlayers = number
    }
    
    func resetPlayerArray(){
        for player in playersArray{
            player.manager = GameManager()
            numPlayers = numPlayers + 1
        }
        playerPointer = 0
        manager = playersArray[playerPointer].manager
    }
    
    func nextPlayer() ->(Bool, Bool){
        manager?.nextRound()
        
        var isNewRound = false //checks if the next player is starting a new round
        var isGameOver = false //checks if all players have lost
        playerPointer += 1
        
        //if the player pointer is beyond the array, its a new round
        if playerPointer >= playersArray.count {
            isNewRound = true
            playerPointer = 0
        }
        
        //do this loop until we find a player who hasn't lost already
        //ie, get next player who's still active
        while (playersArray[playerPointer].manager.didLose) {
            playerPointer += 1
            
            //if the player pointer is beyond array, its a new round
            if playerPointer >= playersArray.count {
                //if its already been found as a new round, nobody is left
                if isNewRound == true {
                    isGameOver = true
                    break
                }
                isNewRound = true
                playerPointer = 0
            }
        }
        if !isGameOver{
            manager = playersArray[playerPointer].manager
        }
        
        return (isNewRound, isGameOver)
    }
    
    func getPlayerName() -> String{
        return playersArray[playerPointer].name
    }
    
    func getWinner() -> Player{
        var winner = playersArray[0]
        var winningScore = playersArray[0].manager.getScore()
        for player in playersArray {
            if player.manager.getScore() > winningScore {
            winningScore = player.manager.getScore()
            winner = player
        }
        }
        return winner
    }
    
    
    @objc func swipeUp(){
        manager?.swipeUp()
    }
    
    @objc func swipeLeft(){
        manager?.swipeLeft()
    }
    
    @objc func swipeRight(){
        manager?.swipeRight()
    }
    
    @objc func swipeDown(){
        manager?.swipeDown()
    }
    
}
