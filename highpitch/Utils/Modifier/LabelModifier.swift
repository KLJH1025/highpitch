//
//  LabelModifier.swift
//  highpitch
//
//  Created by yuncoffee on 10/17/23.
//

import Foundation
import SwiftUI

struct TextWithIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.title
            configuration.icon
        }
    }
}
