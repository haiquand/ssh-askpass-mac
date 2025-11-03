//
//  ContentView.swift
//  ssh-askpass-mac
//
//  Created by haiquand on 2025/10/3.
//
//  SPDX-License-Identifier: MIT
//

import SwiftUI

let trackedEnvKeys = [
    "SSH_AUTH_SOCK",
    "SSH_ASKPASS",
    "SSH_ASKPASS_REQUIRE",
    "SSH_ASKPASS_PROMPT",
    "GIT_ASKPASS",
    "SSH_SK_PROVIDER"
]

func getAllEnvInfo() -> String {
    let env = ProcessInfo.processInfo.environment
    
    let lines = trackedEnvKeys.map { key in
        let value = env[key] ?? "NONE"
        return "\(key): \(value)"
    }
        .joined(separator: "\n")
    
    return """
        --- Environment Variables ---
        \(lines)
        """
}

struct ContentView: View {
    let info: String
    
    @State private var pin: String = ""
    
    @FocusState private var pinFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            #if ASKPASS_DEBUG
            Text(getAllEnvInfo())
            #endif
            
            Text(info.isEmpty ? "Enter PIN" : info)

            Form {
                SecureField(text: $pin, prompt: Text("Enter PIN")) {
                    Text("PIN")
                }
                .focused($pinFieldFocused)
                .onSubmit {
                    confirmAction()
                }
            }

            HStack() {
                Spacer()
                Button("Cancel") {
                    cancelAction()
                }
                .keyboardShortcut(.cancelAction)
            
                Button("Confirm") {
                    confirmAction()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .frame(minWidth: 450)
        .fixedSize()
        .onAppear {
            pinFieldFocused = true
        }
    }
    
    func confirmAction() {
        print("\(pin)")
        exit(0)
    }
    
    func cancelAction() {
        print("")
        exit(1)
    }
}

//#Preview("") {
//    ContentView(info: "Enter PIN:")
//}
