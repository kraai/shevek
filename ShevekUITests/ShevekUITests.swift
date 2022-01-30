//
//  Copyright 2021, 2022 Matthew James Kraai
//
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  ShevekUITests.swift
//  ShevekUITests
//
//  Created by Matthew James Kraai on 11/30/21.
//

import XCTest

class ShevekUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSnapshot() throws {
        let app = XCUIApplication()
        setupSnapshot(app, waitForAnimations: false)
        app.launch()

        app.navigationBars["Inbox"].buttons["Add Item"].tap()
        app.tables.textFields["Title"].tap()
        let title = "Read *Alpha: Eddie Gallagher and the War for the Soul of the Navy Seals* by David Phillips."
        app.typeText(title)
        snapshot("1-NewItem")
        app.navigationBars["New Item"].buttons["Add"].tap()
        snapshot("2-Inbox")
        app.tables.cells["\(title.filter { $0 != "*" }), Info"].children(matching: .other).element(boundBy: 0).tap()
        app.tables.textFields["Title"].tap()
        snapshot("3-ItemDetails")
        app.navigationBars["Details"].buttons["Done"].tap()

        app.tabBars["Tab Bar"].buttons["Projects"].tap()
        app.navigationBars["Projects"].buttons["Add Project"].tap()
        app.tables.textFields["Title"].tap()
        app.typeText("Read *Alpha: Eddie Gallagher and the War for the Soul of the Navy Seals* by David Phillips.")
        snapshot("4-NewProject")
        app.navigationBars["New Project"].buttons["Add"].tap()
        snapshot("5-Projects")

        app.tabBars["Tab Bar"].buttons["Next Actions"].tap()
        app.navigationBars["Next Actions"].buttons["Add Action"].tap()
        app.tables.textFields["Title"].tap()
        app.typeText("Place a hold on *Alpha: Eddie Gallagher and the War for the Soul of the Navy Seals* by David Phillips.")
        snapshot("6-NewAction")
        app.navigationBars["New Action"].buttons["Add"].tap()
        snapshot("7-NextActions")

        app.tabBars["Tab Bar"].buttons["Waiting Fors"].tap()
        app.navigationBars["Waiting Fors"].buttons["Add Waiting For"].tap()
        app.tables.textFields["Title"].tap()
        app.typeText("*Alpha: Eddie Gallagher and the War for the Soul of the Navy Seals* to be available")
        snapshot("8-NewWaitingFor")
        app.navigationBars["New Waiting For"].buttons["Add"].tap()
        snapshot("9-WaitingFors")
    }

}
