//
//  Styles.swift
//  BlurEffectTest
//
//  Created by Konrad Zdunczyk on 11/11/2019.
//  Copyright © 2019 Konrad Zdunczyk. All rights reserved.
//

import UIKit

enum EffectStyle: String, CaseIterable {
    case hide
    case blur

    var name: String {
        return self.rawValue
    }

    var index: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }

    static func style(for index: Int) -> Self {
        return Self.allCases[index]
    }
}

enum BlurEffectStyle: String, CaseIterable {
    case extraLight
    case light
    case dark

    var uiKitStyle: UIBlurEffect.Style {
        switch self {
        case .extraLight:
            return .extraLight
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var name: String {
        return self.rawValue
    }

    var index: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }

    static func style(for index: Int) -> Self {
        return Self.allCases[index]
    }
}
