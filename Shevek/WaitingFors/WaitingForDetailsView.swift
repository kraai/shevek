//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  WaitingForDetailsView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 11/28/21.
//

import SwiftUI

struct WaitingForDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var waiting_for: WaitingFor?
    @State private var title: String
    @FocusState private var titleFieldIsFocused: Bool

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                    .focused($titleFieldIsFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            titleFieldIsFocused = true
                        }
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        waiting_for = nil
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        waiting_for!.title = title

                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }

                        waiting_for = nil
                    } label: {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    init(waiting_for: Binding<WaitingFor?>, title: String) {
        _waiting_for = waiting_for
        _title = State(initialValue: title)
    }
}

struct WaitingForDetailsView_Previews: PreviewProvider {
    @State static private var waiting_for: WaitingFor? = WaitingFor(context: PersistenceController(inMemory: true).container.viewContext)

    static var previews: some View {
        waiting_for!.title = "Waiting For 0"
        return WaitingForDetailsView(waiting_for: $waiting_for, title: waiting_for!.title!)
    }
}
