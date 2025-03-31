//
//  ContentView.swift
//  Codaic
//
//  Created by Oliver Herklotz on 31.03.2025.
//

import SwiftUI

struct ContentView: View {
    init() {
        guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else { return }
        guard let libDynloadPath = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else { return }
        setenv("PYTHONPATH", [pythonPath, libDynloadPath].compactMap { $0 }.joined(separator: ":"), 1)
        
        Py_Initialize()
        PyRun_SimpleString("""
        print(\"3 * 5 =\", 3*5)
        print(\"Hello World!\")
        """)
    }
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
