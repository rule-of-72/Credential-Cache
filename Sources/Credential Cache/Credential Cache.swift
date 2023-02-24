//
//  Credential Cache.swift
//

import Foundation

public class CredentialCache {

    public enum KeychainError: Error, Equatable {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }

    public typealias Credential = (username: String, password: String)

    public init(server: String) {
        self.server = server
    }

    public func saveKey(credential: Credential) throws {
        try deleteKey()

        let account = credential.username
        let password = credential.password.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String:                kSecClassInternetPassword,
            kSecAttrServer as String:           server,
            kSecAttrAccount as String:          account,
            kSecValueData as String:            password,
            kSecAttrSynchronizable as String:   kCFBooleanTrue!
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    public func retrieveKey() throws -> Credential {
        var item: CFTypeRef?
        let query: [String: Any] = [
            kSecClass as String:                kSecClassInternetPassword,
            kSecAttrServer as String:           server,
            kSecAttrSynchronizable as String:   kCFBooleanTrue!,
            kSecMatchLimit as String:           kSecMatchLimitOne,
            kSecReturnAttributes as String:     true,
            kSecReturnData as String:           true
        ]

        let status = SecItemCopyMatching(query as CFDictionary, &item)
        switch status {
            case errSecSuccess:
                break

            case errSecItemNotFound:
                throw KeychainError.noPassword

            default:
                throw KeychainError.unhandledError(status: status)
        }

        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData
        }

        return Credential(username: account, password: password)
    }

    public func deleteKey() throws {
        let query: [String: Any] = [
            kSecClass as String:                kSecClassInternetPassword,
            kSecAttrServer as String:           server,
            kSecAttrSynchronizable as String:   kCFBooleanTrue!
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    private let server: String

}
