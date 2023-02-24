//
//  Credential Cache tests.swift
//

import XCTest
@testable import CredentialCache

final class CredentialCacheTests: XCTestCase {

    func testSaveKey() throws {
        let credential = CredentialCache.Credential(username: "foo", password: "bar")
        let cache = CredentialCache(server: "api.example.com")

        // Requires a test hosting app! Otherwise you get errSecMissingEntitlement (-34018)
        try cache.saveKey(credential: credential)
        let fetchedCredential = try cache.retrieveKey()
        XCTAssertTrue(
            credential.username == fetchedCredential.username &&
            credential.password == fetchedCredential.password
        )

        try cache.deleteKey()

        XCTAssertThrowsError(try cache.retrieveKey()) { error in
            XCTAssertEqual(error as! CredentialCache.KeychainError, .noPassword)
        }

    }

}
