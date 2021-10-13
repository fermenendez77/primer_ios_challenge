//
//  Constants.swift
//  PrimerTestApp
//
//  Created by Fernando Menendez on 13/10/2021.
//

import Foundation

let baseURL = "api.staging.primer.io"
let apiKey = "5a5d5931-ece2-4d29-a314-e0c374792ecb"
let dateTimeFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"

let dateFormetter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = dateTimeFormat
    return formatter
}()
