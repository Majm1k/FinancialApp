//
//  ExtensionPressedButton.swift
//  FinancialApp
//
//  Created by Дмитрий Рузайкин on 21.11.2021.
//

import Foundation
import UIKit

//Расширение для анимации нажатия кнопок
extension UIButton {

        func pulsate() {
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.2
            pulse.fromValue = 0.95
            pulse.toValue = 1.0
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0

            layer.add(pulse, forKey: "pulse")
        }
    }
