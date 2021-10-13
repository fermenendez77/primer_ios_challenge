import XCTest
@testable import PrimerSDK

final class PrimerSDKTests: XCTestCase {
    
    
    func testSettings() {
        XCTAssert(Primer.shared.delegate == nil)
    }
}
