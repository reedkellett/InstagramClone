//
//  InstagramCloneApp.swift
//  InstagramClone
//
//  Created by Reed Kellett on 3/10/21.
//

import SwiftUI
import Firebase

@main
struct InstagramCloneApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared)
        }
    }
}

