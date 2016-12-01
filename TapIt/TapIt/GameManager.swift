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

    
    func recieveData(didTap wasTapped: Bool, didRotate wasRotated: Bool, didShake wasShook : Bool){
        didTap = wasTapped
        didRotate = wasRotated
        didShake = wasShook
    }
        
}
