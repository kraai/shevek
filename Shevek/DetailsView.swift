//
//  Copyright 2021 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  DetailsView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 11/28/21.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var item: Item?
    @State private var title: String
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
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        item = nil
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        item!.title = title

                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }

                        item = nil
                    } label: {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    init(item: Binding<Item?>, title: String) {
        _item = item
        _title = State(initialValue: title)
    }
}

struct DetailsView_Previews: PreviewProvider {
    @State static private var item: Item? = Item(context: PersistenceController(inMemory: true).container.viewContext)

    static var previews: some View {
        item!.title = "Item 0"
        return DetailsView(item: $item, title: item!.title!)
    }
}
