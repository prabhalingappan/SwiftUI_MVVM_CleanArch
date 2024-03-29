//
//  FetchBooksUseCaseImplTests.swift
//  SwiftUI_MVVM_CleanArch
//
//  Created by Kalaiprabha L on 11/01/24.
//

import XCTest
import NetworkManager
@testable import SwiftUI_MVVM_CleanArch

final class FetchBooksUseCaseImplTests: XCTestCase {
    var mockBookRepository: MockBookRepository!
    var bookUseCase: FetchBooksUseCaseImpl!
    
    override func setUp() {
        super.setUp()
        
        mockBookRepository = MockBookRepository()
        bookUseCase = FetchBooksUseCaseImpl(bookRepository: mockBookRepository)
    }
    
    override func tearDown() {
        super.tearDown()
       
        mockBookRepository = nil
        bookUseCase = nil
    }
    
    func testFetchBookSuccess() async throws {
        mockBookRepository.mockBookDomainDTO = MockData.bookDomainDTO

        let result = try await bookUseCase.execute()
        XCTAssertEqual(result.count, 1, "Expected one book")
    }
    
    func testFetchBookNoData() async throws {
        mockBookRepository.mockBookDomainDTO = []

        let result = try await bookUseCase.execute()
        XCTAssert(result.isEmpty)
    }

    func testFetchBookFailure() async throws {
        mockBookRepository.mockError = ErrorResponse.invalidData

        do {
            _ = try await bookUseCase.execute()
            XCTFail("Success not expected")
        } catch {
            XCTAssertEqual(error.localizedDescription, ErrorResponse.invalidData.localizedDescription)
        }
    }
}
