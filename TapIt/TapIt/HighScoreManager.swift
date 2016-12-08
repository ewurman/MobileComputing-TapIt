//
//  HighScoreManager.swift
//  TapIt
//
//  Created by Erik Wurman on 12/7/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import Foundation

class HighScoreManager{
    private let filename = "HighScores.txt"
    
    
    private func readHighScoresArr() ->[String]{
        //file should be 3 values separated by ,
        //returns the highscore in string version of the appropriate gameMode
        var contents = "0,0,0"
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let path = directory.appendingPathComponent(filename)
            do{
                contents = try String(contentsOf: path, encoding: String.Encoding.utf8)
            }
            catch let error as NSError{
                print("error loading contentsOf url \(filename)")
                print(error.localizedDescription)
            }
        }
        return contents.components(separatedBy: ",")
    }
    
    func readGameModesHighScore(gameMode: Int) -> String{
        let highScoresArr = readHighScoresArr()
        return highScoresArr[gameMode]
    }
    
    private func writeHighScoresToFile(highScoresArr: [String]){
        var text = highScoresArr[0]
        for i in 1..<(highScoresArr.count) {
            text += ",\(highScoresArr[i])"
        }
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let path = directory.appendingPathComponent(filename)
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch let error as NSError{
                print("error writing to url \(filename)")
                print(error.localizedDescription)
            }
        }
    }
    
    func updateHighScoreFor(gameMode: Int, highScore: Int){
        var highScoresArr = readHighScoresArr()
        if highScore > Int(highScoresArr[gameMode])!{
            highScoresArr[gameMode] = String(highScore)
        }
        writeHighScoresToFile(highScoresArr: highScoresArr)
    }

}


