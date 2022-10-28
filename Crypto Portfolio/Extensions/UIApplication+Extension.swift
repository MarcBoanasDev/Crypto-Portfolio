//
//  UIApplication+Extension.swift
//  TrackMyCrypto
//
//  Created by Marc Boanas on 20/10/2022.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
