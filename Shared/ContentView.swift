//
//  ContentView.swift
//  Shared
//
//  Created by Marquis Kurt on 25/1/22.
//  This file is part of Codename Shout.
//
//  Codename Shout is non-violent software: you can use, redistribute, and/or modify it under the terms of the CNPLv7+
//  as found in the LICENSE file in the source code root directory or at <https://git.pixie.town/thufie/npl-builder>.
//
//  Codename Shout comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftUI
import Chica

struct ContentView: View {

    /// The shared Chica authentication object.
    ///
    /// This is used to handle authentication to the Gopherdon server and watch for state changes.
    @ObservedObject private var chicaAuth: Chica.OAuth = Chica.OAuth.shared

    @State private var showAuthSheet: Bool = false

    var body: some View {
        VStack {
            if chicaAuth.authState == .signedOut {
#if os(macOS)
                Image("Cliffs")
                    .resizable()
                    .scaledToFill()
#else
                authDialog
#endif
            } else {
                Text("Welcome to Shout")
                    .padding()
            }
        }
#if os(macOS)
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            if chicaAuth.authState == .signedOut {
                showAuthSheet = true
            }
        }
        .sheet(isPresented: $showAuthSheet) {
            authDialog
                .frame(width: 500, height: 400)
                .toolbar {
                    ToolbarItem {
                        Button {
                            showAuthSheet.toggle()
                        } label: {
                            Text("general.cancel")
                        }
                        .keyboardShortcut(.cancelAction)
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            authDialog.startAuthentication()
                        } label: {
                            Text("auth.login.button")
                        }
                        .keyboardShortcut(.defaultAction)
                    }

                }
        }
#endif
    }

    var authDialog: AuthenticationView {
        AuthenticationView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}