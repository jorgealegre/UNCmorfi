//
//  UserRunCount.swift
//  UNCmorfi
//
//  Created by Igor Andruskiewitsch on 16/04/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

protocol AppRunCount {
    func increment()
    func reset()
    var reachedLimit: Bool { get }
}

class AppRunCountImpl: AppRunCount {
    
    // MARK: variables
    private let KEY = "AppRunCount"
    private let LIMIT = 10
    private let defaults = UserDefaults.standard

    // MARK: private methods
    private func getCount() -> Int {
        let count = defaults.integer(forKey: KEY)
        if count == 0 { defaults.set(0, forKey: KEY) }
        return count
    }
    
    private func setCount(_ count: Int) {
        defaults.set( count, forKey: KEY)
    }

    // MARK: protocol implementation
    var reachedLimit: Bool {
        get {
            return getCount() > LIMIT
        }
    }
    
    func increment() {
        setCount(getCount() + 1)
    }
    
    func reset() {
        setCount(0)
    }
    
}
