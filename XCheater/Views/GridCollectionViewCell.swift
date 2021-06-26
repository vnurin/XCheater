//
//  GridCollectionViewCell.swift
//  XCheater
//
//  Created by Vahagn Nurijanyan on 2021-06-26.
//  Copyright © 2021 X INC. All rights reserved.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    var letter: String! {
        willSet {
            if letter == nil {
                addSubview(letterLabel)
                letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                letterLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
                letterLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
                letterLabel.font = UIFont.boldSystemFont(ofSize: bounds.width + 32.0)
                letterLabel.backgroundColor = .yellow
                letterLabel.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        didSet {
            letterLabel.text = letter
            if letter == "X" {
                letterLabel.textColor = .red
            }
            else if letter == "O" {
                letterLabel.textColor = .green
            }
        }
    }
    private var letterLabel = UILabel()
    
}
