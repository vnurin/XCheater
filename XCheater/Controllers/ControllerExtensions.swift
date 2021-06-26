//
//  ControllerExtensions.swift
//  XCheater
//
//  Created by Vahagn Nurijanyan on 2021-06-26.
//  Copyright © 2021 X INC. All rights reserved.
//

import UIKit

extension UIViewController {

    //Yes or No action sheet having action only for Yes
    func ask(title: String?, message: String? = nil, yesAction: ((UIAlertAction)->Void)?) {
        let askController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        askController.addAction(UIAlertAction(title: "Yes", style: .default, handler: yesAction))
        askController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(askController, animated: true)
    }
    
}
