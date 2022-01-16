//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  ActionDetailsView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 1/16/22.
//

import SwiftUI

struct ActionDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var action: Action?
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
                        action = nil
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        action!.title = title

                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }

                        action = nil
                    } label: {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    init(action: Binding<Action?>, title: String) {
        _action = action
        _title = State(initialValue: title)
    }
}

struct ActionDetailsView_Previews: PreviewProvider {
    @State static private var action: Action? = Action(context: PersistenceController(inMemory: true).container.viewContext)

    static var previews: some View {
        action!.title = "Action 0"
        return ActionDetailsView(action: $action, title: action!.title!)
    }
}
