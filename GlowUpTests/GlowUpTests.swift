import XCTest
@testable import GlowUp
@MainActor
final class GlowUpTests: XCTestCase {

    func testPriceConversionToTenge() {
        let product = Product(id: 1, brand: "nyx", name: "Lipstick", price: "10.0", image_link: nil, description: nil, product_type: nil, rating: nil)
        
        //10 * 510 = 5100
        XCTAssertEqual(product.priceInTenge, "₸ 5100", "N0t working")
    }
    
    func testEmptyPriceHandling() {
        let product = Product(id: 2, brand: "elf", name: "Brush", price: nil, image_link: nil, description: nil, product_type: nil, rating: nil)
        
        XCTAssertEqual(product.priceInTenge, "₸ --", " Not working ")
    }

    func testImageURLCreation() {
        let link = "https://example.com/image.png"
        let product = Product(id: 3, brand: "mac", name: "Powder", price: "20.0", image_link: link, description: nil, product_type: nil, rating: nil)
        
        XCTAssertNotNil(product.imageURL, "URL wasnt created")
        XCTAssertEqual(product.imageURL?.absoluteString, link)
    }
    
    func testProductDecoding() throws {
        let json = """
        {
            "id": 100,
            "brand": "maybelline",
            "name": "Mascara",
            "price": "8.5",
            "rating": 4.5
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let product = try decoder.decode(Product.self, from: json)
        
        XCTAssertEqual(product.name, "Mascara")
        XCTAssertEqual(product.rating, 4.5)
    }

    func testPasswordValidation() {
        let shortPass = "123"
        let goodPass = "123456"
        
        XCTAssertFalse(shortPass.count >= 6, "The short password must be rejected.")
        XCTAssertTrue(goodPass.count >= 6, "A good password must be accepted.т")
    }

    // (Review Model)
    func testReviewInitialization() {
        let data: [String: Any] = [
            "productId": 101,
            "userName": "Aruzhan",
            "text": "Great!",
            "timestamp": 123456789.0
        ]
        
        let review = Review(id: "test_id", data: data)
        
        XCTAssertNotNil(review)
        XCTAssertEqual(review?.userName, "Aruzhan")
        XCTAssertEqual(review?.text, "Great!")
    }

    func testInvalidReviewInitialization() {
        let data: [String: Any] = [
            "productId": 101,
            "userName": "Aruzhan"
        ]
        
        let review = Review(id: "bad_id", data: data)
        
        XCTAssertNil(review, "A review should not be created without the required fields.")
    }
    
    //(Search Logic)
    func testSearchQueryCleaning() {
        let dirtyQuery = "  NYX  "
        let cleanQuery = dirtyQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        XCTAssertEqual(cleanQuery, "nyx", "The search should remove spaces and make the text small")
    }
    
  
    func testSecureURL() {
        let httpLink = "http://site.com/img.jpg"
        let product = Product(id: 4, brand: "x", name: "x", price: nil, image_link: httpLink, description: nil, product_type: nil, rating: nil)
       
        XCTAssertEqual(product.imageURL?.scheme, "http")
    }
    

    func testReviewToDictionary() {
        let review = Review(id: "1", data: [
            "productId": 5,
            "userName": "User",
            "text": "Hello",
            "timestamp": 100.0
        ])!
        
        let dict = review.toDictionary
        
        XCTAssertEqual(dict["userName"] as? String, "User")
        XCTAssertEqual(dict["text"] as? String, "Hello")
    }

        
        func testEmailValidation() {
            let invalidEmail = "test"
            let validEmail = "test@example.com"
  
            XCTAssertFalse(invalidEmail.contains("@") && invalidEmail.contains("."), "Email validation should fail")
            XCTAssertTrue(validEmail.contains("@"), "Email should contain @")
        }

        func testAuthViewModelInit() {
            let viewModel = AuthViewModel()
            XCTAssertFalse(viewModel.isLoading, "Loading should be false initially")
            XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially")
        }

        func testPriceFormattingZero() {
            let product = Product(id: 99, brand: "x", name: "x", price: "0.0", image_link: nil, description: nil, product_type: nil, rating: nil)
            XCTAssertEqual(product.priceInTenge, "₸ 0", "Zero price should be handled correctly")
        }
        

        func testURLStringSafety() {
            let brokenLink = ""
            let product = Product(id: 5, brand: "x", name: "x", price: nil, image_link: brokenLink, description: nil, product_type: nil, rating: nil)
            XCTAssertNil(product.imageURL, "Empty string should result in nil URL")
        }
}
