import XCTest
@testable import PhoneNumber

final class PhoneNumberTests: XCTestCase {

    func testValidation() {
        let number: PhoneNumber = "201-22231 (642) 0"
        XCTAssertTrue(number.isValid)
    }
    
    func testEquatability() {
        let traget: PhoneNumber = "201222316420"
        let value: PhoneNumber = "201222316420"
        XCTAssertEqual(traget, value)
    }
    
    func testDecodability() {
        let jsonData = """
        {
        "mobile": "201222316420"
        }
        """.data(using: .utf8)
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(Mobile.self, from: jsonData ?? .init())
            XCTAssertNotNil(object.mobile)
        } catch {
            XCTAssertThrowsError(error)
        }
        
    }
    
    func testEncodability() {
        let mobile = Mobile(mobile: "201222316420")
        /*let target = """
        {
        "mobile": "201222316420"
        }
        """.data(using: .utf8) ?? .init()*/
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        do {
            let data = try encoder.encode(mobile)
            let object = try decoder.decode(Mobile.self, from: data)
            XCTAssertEqual(mobile.mobile, object.mobile)
        } catch {
            XCTAssertThrowsError(error)
        }
    }
    
    struct Mobile: Codable {
        let mobile: PhoneNumber?
    }
    
    func testHashability() {
        var target = Dictionary<PhoneNumber, String>()
        target["201222316420"] = "Jamal alayq"
        
        XCTAssertEqual(target["201222316420"], "Jamal alayq")
    }
    
    func testLanguageConverting() {
        var target: PhoneNumber = "٢٠١٢٢٢٣١٦٤٢٠"
        let value: PhoneNumber = "201222316420"
        XCTAssertEqual(target.converted(), value)
    }
    
    func testCleaning() {
        var value: PhoneNumber = "201222316420"
        value.dialCode = "20"
        let target: PhoneNumber = "1222316420"
        XCTAssertEqual(value.separated(), target)
    }
    
    static var allTests = [
        ("testValidation", testValidation),
        ("testEquatability", testEquatability),
        ("testDecodability", testDecodability),
        ("testEncodability", testEncodability),
        ("testHashability", testHashability),
        ("testLanguageConverting", testLanguageConverting),
    ]
}
