//
//  File.swift
//  
//
//  Created by Fernando Menendez on 07/10/2021.
//

import Foundation
import UIKit

public struct PrimerTheme {
    
    public let cornerRadiusTheme : PrimerCornerRadiusTheme
    public let paymentButtonColor : UIColor
    public let colorTheme : PrimerColorTheme
    
    public init(cornerRadiusTheme : PrimerCornerRadiusTheme = PrimerCornerRadiusTheme(),
                paymentButtonColor : UIColor = .systemGreen,
                colorTheme : PrimerColorTheme = PrimerColorTheme() ) {
        self.cornerRadiusTheme = cornerRadiusTheme
        self.paymentButtonColor = paymentButtonColor
        self.colorTheme = colorTheme
    }
}
