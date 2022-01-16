//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  NextActionsView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 1/16/22.
//

import SwiftUI
import CoreData

struct NextActionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Action.title, ascending: true)],
        animation: .default)
    private var actions: FetchedResults<Action>
    @State private var isShowingAddSheet = false
    @State private var action: Action?

    var body: some View {
        NavigationView {
            List {
                ForEach(actions) { action in
                    HStack {
                        Text(try! AttributedString(markdown: action.title!, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                        Spacer()
                        Button {
                            self.action = action
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .onDelete(perform: deleteActions)
            }
            .navigationTitle("Next Actions")
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Label("Add Action", systemImage: "plus")
                    }
                }
            }
            Text("Select an action")
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $isShowingAddSheet) {
            isShowingAddSheet = false
        } content: {
            AddActionView(isPresented: $isShowingAddSheet)
        }
        .sheet(item: $action) {
            action = nil
        } content: { action in
            ActionDetailsView(action: $action, title: action.title!)
        }
    }

    private func deleteActions(offsets: IndexSet) {
        withAnimation {
            offsets.map { actions[$0] }.forEach(viewContext.delete)

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

struct NextActionsView_Previews: PreviewProvider {
    static var previews: some View {
        NextActionsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
