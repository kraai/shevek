//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  InboxView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 1/15/22.
//

import SwiftUI
import CoreData

struct InboxView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var isShowingAddSheet = false
    @State private var item: Item?

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(try! AttributedString(markdown: item.title!, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                        Spacer()
                        Button {
                            self.item = item
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $isShowingAddSheet) {
            isShowingAddSheet = false
        } content: {
            AddItemView(isPresented: $isShowingAddSheet)
        }
        .sheet(item: $item) {
            item = nil
        } content: { item in
            ItemDetailsView(item: $item, title: item.title!)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
