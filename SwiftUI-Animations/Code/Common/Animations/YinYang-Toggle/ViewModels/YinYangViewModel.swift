//
//  YinYangViewModel.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

@Observable
class YinYangViewModel {
    
    // MARK: - Variables
    var forTest = false
    var themeToggled: Bool = false

    
    // MARK: - Inits
    init(forTest: Bool = false) {
        self.forTest = forTest
    }
    
    
    // MARK: - Functions
}
