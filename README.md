# Credential Cache

Stores and retrieves a credential for a particular host in the user’s Keychain.
- If you have multiple apps with the same Keychain Sharing group identifier, the credentials propagate across your apps.
- If the user has iCloud Keychain enabled, the credentials propagate across their devices.

```swift
var host: String
var cachedCredentials: CredentialCache.Credential? {
    get {
        let credentialCache = CredentialCache(server: host)
        if let fetchedCredential = try? credentialCache.retrieveKey() {
            return fetchedCredential
        } else {
            return nil
        }
    }

    set {
        let credentialCache = CredentialCache(server: host)
        if let newCredential = newValue {
            try? credentialCache.saveKey(credential: newCredential)
        } else {
            try? credentialCache.deleteKey()
        }
    }
}
```

# Credential Cache UI

Provides a convenient prompt for credentials.

```swift
let credUI = CredentialCacheUI(
    title: "LOG IN",
    message: "Enter your username and password.",
    usernamePlaceholder: "(Username)",
    passwordPlaceholder: "(Password)"
)

credUI.promptForKey(hostingViewController: self) { [weak self] credential in
    guard let self = self else { return }
    
    if let credential = credential {
        // log in
    } else {
        // display error
    }
}
```

If appropriate for your application, you can disable the obscuring of the password:

```swift
credUI.promptForKey(hostingViewController: self, obscurePassword: false) { [weak self] credential in
⋮
}
```

# Testing

Unfortunately, Xcode does not yet support the ability to assign a **Host Application** for test cases in Swift Package Manager packages.

The test case requires a Host Application, because writing to the Keychain requires an entitlement. Only *apps* can have entitlements — not libraries, frameworks, packages, etc …

Without a Host Application, the test will fail with the following error:

```
testSaveKey(): failed: caught error: "unhandledError(status: -34018)"
```

To run the test case:
- Add a new Xcode test bundle to your app’s project.
- Add the test case source file to the test bundle.
- Configure the test bundle so your app is the hosting app.
    - Assumes your app has the Keychain entitlement.
    - In the Xcode project settings, click on the test bundle target.
    - Then click on the General tab, the Testing section, and the Host Application selector.
