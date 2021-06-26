//
//  ViewExtensions.swift
//  XCheater
//
//  Created by Vahagn Nurijanyan on 2021-06-26.
//  Copyright © 2021 X INC. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        setTitle(title, for: .normal)
        backgroundColor = .brown
        layer.cornerRadius = 5.0
    }
    
}
