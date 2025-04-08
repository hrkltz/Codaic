
//
//  ContactCard.swift
//  Codaic
//
//  Created by Oliver Herklotz on 06.04.2025.
//

import SwiftUI

struct LabelValueActionComponent: View {
    var label: String
    var value: String
    var actionIconLabel: String
    var onAction: () -> Void
    
    
    var body: some View {
        HStack() {
            Text(label)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
            Button(action: onAction) {
                Image(systemName: actionIconLabel)
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    LabelValueActionComponent(label: "WLAN-IP", value: "192.168.1.100", actionIconLabel: "arrow.clockwise") {
        print("onAction")
    }
}
