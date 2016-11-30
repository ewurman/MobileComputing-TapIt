//
//  Actions.swift
//  TapIt
//
//  Created by Erik Wurman on 11/30/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import Foundation

class Actions {
    //model
    enum Actions{
        case Gesture(String)
    }
    
    var gameActions: Dictionary<Int, Actions> = [
        1: Actions.Gesture("Tap It")
    ]
    
    
    
}
