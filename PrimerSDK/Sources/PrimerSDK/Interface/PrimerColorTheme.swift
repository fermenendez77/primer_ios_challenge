//
//  PrimerColorTheme.swift
//  
//
//  Created by Fernando Menendez on 13/10/2021.
//

import Foundation
import UIKit

public struct PrimerColorTheme {
    
    public let background : UIColor
    public let label : UIColor
    public let loadingTintColor : UIColor
    
    public init(background : UIColor = .systemBackground,
                label : UIColor = .label,
                loadingTintColor : UIColor = .systemGray) {
        self.background = background
        self.label = label
        self.loadingTintColor = loadingTintColor
    }
}
