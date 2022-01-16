//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  ProjectDetailsView.swift
//  Shevek
//
//  Created by Matthew James Kraai on 1/16/22.
//

import SwiftUI

struct ProjectDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var project: Project?
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
                        project = nil
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        project!.title = title

                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }

                        project = nil
                    } label: {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    init(project: Binding<Project?>, title: String) {
        _project = project
        _title = State(initialValue: title)
    }
}

struct ProjectDetailsView_Previews: PreviewProvider {
    @State static private var project: Project? = Project(context: PersistenceController(inMemory: true).container.viewContext)

    static var previews: some View {
        project!.title = "Project 0"
        return ProjectDetailsView(project: $project, title: project!.title!)
    }
}
