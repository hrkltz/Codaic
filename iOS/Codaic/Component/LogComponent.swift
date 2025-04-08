//
//  LogView.swift
//  Codaic
//
//  Created by Oliver Herklotz on 08.04.2025.
//

import SwiftUI

struct LogComponent: View {
    let logEntryArray: [LogEntryModel]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Zeit")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                Text("Nachricht")
                    .bold()
            }
            Divider()
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(logEntryArray) { entry in
                            HStack(alignment: .top) {
                                Text(entry.timestamp)
                                    .frame(width: 80, alignment: .leading)
                                    .font(.system(.caption, design: .monospaced))
                                
                                Text(entry.message)
                                    .font(.system(.caption, design: .monospaced))
                            }
                        }
                    }
                }
                .onChange(of: logEntryArray.count) { _, _ in
                    // Scroll to the last item when log changes
                    if let last = logEntryArray.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    LogComponent(logEntryArray: [
        LogEntryModel(timestamp: "12:34.567", message: "A log entry."),
        LogEntryModel(timestamp: "12:35.678", message: "A second log entry."),
        LogEntryModel(timestamp: "12:36.789", message: "A third log entry."),
    ])
}
