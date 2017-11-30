//
//  Debouncer.swift
//  KOFA
//
//  Created by may10 on 11/25/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import Foundation

class Debouncer {
    var callback: (() -> Void)?
    private let interval: TimeInterval
    init(interval: TimeInterval) {
        self.interval = interval
    }
    private var timer: Timer?
    func call() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
    }
    
    @objc private func handleTimer(_ timer: Timer) {
        if callback == nil {
            NSLog("Debouncer timer fired, but callback was nil")
        } else {
            NSLog("Debouncer timer fired")
        }
        callback?()
        callback = nil
    }
    
}
