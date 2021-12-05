//
//  Copyright 2021 Matthew James Kraai
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
        snapshot("NewItem")
        app.navigationBars["New Item"].buttons["Add"].tap()
        snapshot("Inbox")
        app.tables.cells["\(title.filter { $0 != "*" }), Info"].children(matching: .other).element(boundBy: 0).tap()
        app.tables.textFields["Title"].tap()
        snapshot("Details")
    }
}
