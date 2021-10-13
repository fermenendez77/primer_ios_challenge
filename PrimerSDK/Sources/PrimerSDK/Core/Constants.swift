//
//  File.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation

let dateTimeFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
let paymentBaseURL = "sdk.api.staging.primer.io"

let dateFormetter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = dateTimeFormat
    return formatter
}()
