//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  WaitingForsView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 1/16/22.
//

import SwiftUI
import CoreData

struct WaitingForsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WaitingFor.title, ascending: true)],
        animation: .default)
    private var waiting_fors: FetchedResults<WaitingFor>
    @State private var isShowingAddSheet = false
    @State private var waiting_for: WaitingFor?

    var body: some View {
        NavigationView {
            List {
                ForEach(waiting_fors) { waiting_for in
                    HStack {
                        Text(try! AttributedString(markdown: waiting_for.title!, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                        Spacer()
                        Button {
                            self.waiting_for = waiting_for
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .onDelete(perform: deleteWaitingFors)
            }
            .navigationTitle("Waiting Fors")
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Label("Add Waiting For", systemImage: "plus")
                    }
                }
            }
            Text("Select a waiting for")
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $isShowingAddSheet) {
            isShowingAddSheet = false
        } content: {
            AddWaitingForView(isPresented: $isShowingAddSheet)
        }
        .sheet(item: $waiting_for) {
            waiting_for = nil
        } content: { waiting_for in
            WaitingForDetailsView(waiting_for: $waiting_for, title: waiting_for.title!)
        }
    }

    private func deleteWaitingFors(offsets: IndexSet) {
        withAnimation {
            offsets.map { waiting_fors[$0] }.forEach(viewContext.delete)

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

struct WaitingForsView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
