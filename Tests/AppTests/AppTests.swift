@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    var app: Application!

    override func setUpWithError() throws {
        try super.setUpWithError()

        print("------------------------------")
        print("------------New Test----------")
        print("------------------------------")

        app = try Application.testable()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.shutdown()
    }

    func testGetStatic() throws {
        let printExpectation = expectation(description: "The /route will serve static HTML content.")

        try app.test(.GET, "", afterResponse: { res in 
            if (res.body.string != "") {
                XCTAssertEqual(res.status, .ok)
                XCTAssertTrue(res.body.string.contains("<html"))
                XCTAssertTrue(res.body.string.contains("</html>"))
            } else {
                XCTFail("Return value from / was nil!")
            }

            printExpectation.fulfill()
        })

        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testHealthRoute() throws {
        let printExpectation = expectation(description: "The /health route will print UP, followed by a timestamp.")
        
        try app.test(.GET, "health", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)

            let healthResponse = try res.content.decode(HealthResponse.self)
            XCTAssertEqual(healthResponse.status, "UP")
            printExpectation.fulfill()
        })

        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
