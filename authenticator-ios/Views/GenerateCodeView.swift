//
//  GenerateCodeView.swift
//  Authenticator
//
//  Created by Kelvin Reid on 4/6/23.
//

import SwiftUI
import CryptoKit
import CoreData

struct GenerateCodeView: View {
    let secret = "SHARED_SECRET" // Replace with your shared secret
    
    @State var code: String = ""
    @State var remainingTime: TimeInterval = 30
    
    var body: some View {
        TabView {
                // Authenticator tab
                NavigationView {
                    ZStack {
                        Color.gray
                            .opacity(0.1)
                            .ignoresSafeArea()
                    VStack {
                        Text("New code in: \(Int(remainingTime)) seconds")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text(code)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxHeight: .infinity)
                        
                        // Tab bar color
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 5)
                            .background(Color.gray.opacity(0.2))
                    }
                    .navigationBarTitle(Text("Authenticator"), displayMode: .large)
                    .onAppear {
                        // Generate the initial code
                        code = getTOTP()
                        
                        // Set up a timer to regenerate the code every 30 seconds
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            remainingTime -= 1
                            if remainingTime <= 0 {
                                code = getTOTP()
                                remainingTime = 30
                            }
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: "lock")
                Text("Authenticator")
            }
            
            // Passwords tab
            NavigationView {
                PasswordsView()
                    .navigationBarTitle(Text("Passwords"), displayMode: .large)
            }
            .tabItem {
                Image(systemName: "key")
                Text("Passwords")
            }
            
            // Settings tab
            NavigationView {
                SettingsView()
                    .navigationBarTitle(Text("Settings"), displayMode: .large)
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
        .accentColor(.green) // set the accent color for the navigation links
    }
    
    // Generate OTP function
    func getTOTP() -> String {
        let keyData = Data(base64Encoded: secret, options: .ignoreUnknownCharacters)!
        let timeInterval = Int64(Date().timeIntervalSince1970 / 30) // 30-second time interval
        let message = String(format: "%016llx", CUnsignedLongLong(timeInterval).bigEndian)
        let data = message.data(using: .utf8)!
        let hash = HMAC<SHA512>.authenticationCode(for: data, using: SymmetricKey(data: keyData))
        
        var truncatedHash = hash.withUnsafeBytes {
            $0.load(as: UInt32.self).bigEndian
        }
        truncatedHash &= 0x7fffffff // Remove the most significant bit
        truncatedHash %= 1000000 // Truncate to a 6-digit code
        return String(format: "%06d", truncatedHash)
    }
}

struct GenerateCodeView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateCodeView()
    }
}
