//
//  AlertExtension.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 10/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

extension UIViewController {
    //Creates an alert with a title and a message
    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    //Creates an alert with a title and a message that stays on screen for given delay
    func presentAlertDelay(title: String, message: String, delay: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
