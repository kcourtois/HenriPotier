//
//  NotificationStrings.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 09/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation

class NotificationStrings {
    //const for parameter keys in the app
    static let didSendUpdateBookQuantityKey: String = "updateBookQuantity"
}

extension Notification.Name {
    //const for notification names in the app
    static let didSendUpdateBookQuantity = Notification.Name("didSendUpdateBookQuantity")
}
