//
//  LastUpdateDateDefaults.swift
//  UNCmorfi
//
//  Created by Igor Andruskiewitsch on 16/04/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

protocol LastUpdateDate {
    var menu: Date? { get }
    var balance: Date? { get }
    
    func updatedMenu()
    func updatedBalances()
}

class LastUpdateDateImpl: LastUpdateDate {

    // MARK: variables
    private let menuKey = "MenuLastUpdateDate"
    private let balanceKey = "BalanceLastUpdateDate"
    private let defaults = UserDefaults()

    // MARK: protocol implementation
    
    var menu: Date? {
        get {
            return defaults.object(forKey: menuKey) as? Date
        }
    }
    
    var balance: Date? {
        get {
            return defaults.object(forKey: balanceKey) as? Date
        }
    }
    
    func updatedMenu() {
        defaults.set(Date(), forKey: menuKey)
    }
    
    func updatedBalances() {
        defaults.set(Date(), forKey: balanceKey)
    }

}
