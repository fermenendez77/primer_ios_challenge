//
//  File.swift
//  
//
//  Created by Fernando Menendez on 07/10/2021.
//

import Foundation

public struct PrimerCornerRadiusTheme {
    
    let sheet : Double
    let buttons : Double
    let textfields : Double
    
    public init(sheet : Double = 16.0,
                buttons : Double = 16.0,
                textfields : Double = 16.0) {
        self.sheet = sheet
        self.buttons = buttons
        self.textfields = textfields
    }
}
