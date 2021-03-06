//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  ContentView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 11/28/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            InboxView()
                .tabItem {
                    Image(systemName: "tray.fill")
                    Text("Inbox")
                }
            ProjectsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Projects")
                }
            NextActionsView()
                .tabItem {
                    Image(systemName: "checkmark.square.fill")
                    Text("Next Actions")
                }
            WaitingForsView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Waiting Fors")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
