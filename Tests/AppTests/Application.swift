import XCTVapor
import App

extension Application {
  static func testable() throws -> Application {
    let app = Application(.testing)
    try configure(app)

    return app
  }
}