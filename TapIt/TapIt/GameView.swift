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
    

    
}

extension UIView{

    func fadeOut(fadeDuration: Double, delayDuration: Double){
        UIView.animate(withDuration: fadeDuration, delay: delayDuration, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 0
            }, completion: nil)
    }
    
    func fadeIn(fadeDuration: Double, delayDuration: Double){
        UIView.animate(withDuration: fadeDuration, delay: delayDuration, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
}
