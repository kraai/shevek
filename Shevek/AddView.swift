//
//  Copyright 2021 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  AddView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 11/28/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    @State private var title = ""
    @FocusState private var titleFieldIsFocused: Bool

    var body: some View {
        NavigationView {
            List {
                TextField("Title", text: $title)
                    .focused($titleFieldIsFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            titleFieldIsFocused = true
                        }
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        let newItem = Item(context: viewContext)
                        newItem.title = title

                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }

                        isPresented = false
                    } label: {
                        Text("Add")
                            .fontWeight(.semibold)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    @State static private var isPresented = true

    static var previews: some View {
        AddView(isPresented: $isPresented)
    }
}
