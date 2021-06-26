//
//  Cheater.swift
//  XCheater
//
//  Created by Vahagn Nurijanyan on 2021-06-26.
//  Copyright © 2021 X INC. All rights reserved.
//

import Foundation

class Cheater {
    
    var firstMoveIsMine = false
    var isPurchased = UserDefaults.standard.bool(forKey: "isPurchased") {
        didSet {
            UserDefaults.standard.set(isPurchased, forKey: "isPurchased")
        }
    }
    var letters = Array<String>(repeating: " ", count: 9)
    //finds index of the recommended (best) move
    //thiis is pseudo-function to fill the first empty cell: the real one suppose to output the index of the recommended empty cell
    func makeRecommendedMove() -> Int? {
        for (index, letter) in letters.enumerated()  {
            if letter == " " {
                letters[index] = firstMoveIsMine ? "X" : "O"
                return index
            }
        }
        return nil
    }
    
}
