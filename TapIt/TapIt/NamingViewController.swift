//
//  NamingViewController.swift
//  TapIt
//
//  Created by Jason Nawrocki on 12/14/16.
//  Copyright © 2016 ErikWurman.cs2505. All rights reserved.
//

import UIKit

class NamingViewController: UIViewController, UITextFieldDelegate {
    
    var numPlayers: Int?
    
    var textFields = [UITextField]()
    
    override func viewDidLoad() {
        
        //programatically make the text fields to put the player name entries
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        let viewHeight = self.view.bounds.size.height - navBarHeight!
        let bufferPixels = CGFloat(viewHeight / CGFloat(numPlayers! + 1))
        
        var yVal = 2 * CGFloat(navBarHeight!)
        
        super.viewDidLoad()
        for i in 1...numPlayers! {
            let width = self.view.bounds.size.width / 3
            let sampleTextField = UITextField(frame: CGRect(x: 20, y:yVal, width: width, height:40))
            sampleTextField.textColor = UIColor.white
            sampleTextField.backgroundColor = UIColor.gray
            sampleTextField.attributedPlaceholder = NSAttributedString(string: "Player \(i)", attributes: [NSForegroundColorAttributeName : UIColor.white])
            sampleTextField.returnKeyType = UIReturnKeyType.done
            sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            sampleTextField.delegate = self
            self.view.addSubview(sampleTextField)
            
            yVal += bufferPixels
            textFields.append(sampleTextField)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getPlayerNames() -> [String]{
        var playerNames = [String]()
        for field in textFields {
            playerNames.append(field.text!)
        }
        return playerNames
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationvc = segue.destination
        if let vc = destinationvc as? MultiplayerViewController {
            vc.playerNames = getPlayerNames()
        }
    }
    
    
    
    
}
