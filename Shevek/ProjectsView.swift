//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  ProjectsView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 1/15/22.
//

import SwiftUI
import CoreData

struct ProjectsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        animation: .default)
    private var projects: FetchedResults<Project>
    @State private var isShowingAddSheet = false
    @State private var project: Project?

    var body: some View {
        NavigationView {
            List {
                ForEach(projects) { project in
                    HStack {
                        Text(try! AttributedString(markdown: project.title!, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
                        Spacer()
                        Button {
                            self.project = project
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .onDelete(perform: deleteProjects)
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
            Text("Select a project")
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $isShowingAddSheet) {
            isShowingAddSheet = false
        } content: {
            AddProjectView(isPresented: $isShowingAddSheet)
        }
        .sheet(item: $project) {
            project = nil
        } content: { project in
            ProjectDetailsView(project: $project, title: project.title!)
        }
    }

    private func deleteProjects(offsets: IndexSet) {
        withAnimation {
            offsets.map { projects[$0] }.forEach(viewContext.delete)

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

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
