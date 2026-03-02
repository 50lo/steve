import XCTest
@testable import steve

final class CLIRunnerTests: XCTestCase {
    func testRunCLIUnknownCommand() {
        let code = runCLI(args: ["nope", "--quiet"])
        XCTAssertEqual(code, UitoolExit.invalidArguments.rawValue)
    }

    func testRunCLINoArgsShowsUsage() {
        let code = runCLI(args: [])
        XCTAssertEqual(code, UitoolExit.success.rawValue)
    }

    func testRunCLIGlobalHelp() {
        let code = runCLI(args: ["-h"])
        XCTAssertEqual(code, UitoolExit.success.rawValue)
    }

    func testRunCLIClickHelp() {
        let code = runCLI(args: ["click", "--help"])
        XCTAssertEqual(code, UitoolExit.success.rawValue)
    }

    func testRunCLIElementsHelp() {
        let code = runCLI(args: ["elements", "--help"])
        XCTAssertEqual(code, UitoolExit.success.rawValue)
    }
}
