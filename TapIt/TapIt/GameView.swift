//
//  GameView.swift
//  TapIt
//
//  Created by Erik Wurman on 12/4/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import UIKit

class GameView: UIView {
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code...!!
    }
    */
    
    //jasons comment

    //Erik's Comment 1  -Line 21
    //Erik's Comment 2  -Line 22
    
    
}

extension UIView{

    func fadeOut(fadeDuration: Double, delayDuration: Double){
        UIView.animate(withDuration: fadeDuration, delay: delayDuration, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 0
            }, completion: nil)
    }
}
