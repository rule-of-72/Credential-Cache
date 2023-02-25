//
//  Credential Cache UI.swift
//

import UIKit
import CredentialCache
import TextCollector

public class CredentialCacheUI {

    public typealias PromptCompletion = (CredentialCache.Credential?) -> Void

    public init(
        title: String,
        message: String? = nil,
        usernamePlaceholder: String = "(Username)",
        passwordPlaceholder: String = "(Password)"
    ) {
        self.title = title
        self.message = message
        self.usernamePlaceholder = usernamePlaceholder
        self.passwordPlaceholder = passwordPlaceholder
    }

    public func promptForKey(hostingViewController viewController: UIViewController, obscurePassword: Bool = true, completion: @escaping PromptCompletion) {
        let textCollector = TextCollector()
        textCollector.addField(originalText: nil, placeholderText: usernamePlaceholder) { text in
            !text.isEmpty
        }

        textCollector.addField(originalText: nil, placeholderText: passwordPlaceholder, secure: obscurePassword) { text in
            !text.isEmpty
        }

        textCollector.show(title: title, message: message, hostingViewController: viewController) { result in
            let credential: CredentialCache.Credential?
            defer {
                completion(credential)
            }

            switch result {
                case .canceled:
                    credential = nil

                case .ok (let results):
                    guard results.count == 2,
                          let username = results[0],
                          let password = results[1]
                    else {
                        credential = nil
                        return
                    }

                    credential = CredentialCache.Credential(username: username, password: password)
            }
        }
    }

    let title: String
    let message: String?
    let usernamePlaceholder: String
    let passwordPlaceholder: String

}
