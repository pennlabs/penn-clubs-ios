//
//  WKPennLoginController.swift
//  WKPennLogin
//
//  Created by Josh Doman on 1/4/20.
//  Copyright © 2020 pennlabs. All rights reserved.
//
import Foundation
import WebKit
import CryptoKit

public enum WKPennLoginError: Error {
    case missingCredentials
    case invalidCredentials
    case platformAuthError
}

public protocol WKPennLoginDelegate {
    func handleLogin(user: WKPennUser)
    func handleError(error: WKPennLoginError)
}

public extension WKPennLoginDelegate {
    func handleError(error: WKPennLoginError) {
        switch error {
        case .missingCredentials:
            print("WKPennLogin is missing credentials.")
        case .invalidCredentials:
            print("WKPennLogin credentials are invalid")
        case .platformAuthError:
            print("Unable to authenticate with Penn Labs.")
        }
    }
}

public class WKPennLoginController: UIViewController, WKUIDelegate {
    
    private var urlStr: String {
        return "https://platform.pennlabs.org/accounts/authorize/?response_type=code&client_id=\(clientID)&redirect_uri=\(escapedRedirectURI)&code_challenge_method=S256&code_challenge=\(codeChallenge)&scope=read+introspection&state="
    }
    
    private var clientID: String {
        WKPennLogin.clientID
    }
    
    private var escapedRedirectURI: String {
        let characterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        return WKPennLogin.redirectURI.addingPercentEncoding(withAllowedCharacters: characterSet)!
    }
    
    /// A random 64-character string
    private let codeVerifier: String = {
        // Source: https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift/33860834
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<64).map{ _ in letters.randomElement()! })
    }()
    
    /// The SHA256 hash of the code verifier
    private var codeChallenge: String {
        let inputData = Data(codeVerifier.utf8)
        var challenge: String
        let digest = SHA256.hash(data: inputData)
        challenge = Data(Array<UInt8>(digest.makeIterator())).base64EncodedString()
        challenge.removeAll(where: { $0 == "=" })
        challenge = challenge.replacingOccurrences(of: "+", with: "-")
        challenge = challenge.replacingOccurrences(of: "/", with: "_")
        return challenge
    }
    
    private var delegate: WKPennLoginDelegate!
    
    convenience public init(delegate: WKPennLoginDelegate) {
        self.init()
        self.delegate = delegate
    }
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "PennKey Login"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        if WKPennLogin.clientID == nil || WKPennLogin.redirectURI == nil {
            delegate.handleError(error: .missingCredentials)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let myURL = URL(string: self.urlStr)!
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - WKNavigationDelegate
extension WKPennLoginController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse, let url = response.url else {
            decisionHandler(.allow)
            return
        }
        
        if url.absoluteString.contains("platform.pennlabs.org") && response.statusCode == 400 {
            // Client ID is invalid if Platform returns a 400 error
            decisionHandler(.cancel)
            self.delegate.handleError(error: .invalidCredentials)
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if url.absoluteString.contains(WKPennLogin.redirectURI) {
            // Successfully logged in and navigated to redirect URI
            decisionHandler(.cancel)
            guard let code = url.absoluteString.split(separator: "=").last else {
                self.delegate.handleError(error: .platformAuthError)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            // Authenticate code
            WKPennNetworkManager.instance.authenticate(code: String(code), codeVerifier: codeVerifier) { (token) in
                guard let token = token else {
                    DispatchQueue.main.async {
                        self.delegate.handleError(error: .platformAuthError)
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                
                // Get user info from Penn Labs Platform
                WKPennNetworkManager.instance.getUserInfo(accessToken: token) { (user) in
                    DispatchQueue.main.async {
                        guard let user = user else {
                            self.delegate.handleError(error: .platformAuthError)
                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                        self.delegate.handleLogin(user: user)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - Cancel
extension WKPennLoginController {
    @objc fileprivate func cancel(_ sender: Any) {
        _ = self.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}

public class WKPennLogin {
    static var clientID: String!
    static var redirectURI: String!
    
    public static func setupCredentials(clientID: String, redirectURI: String) {
        WKPennLogin.clientID = clientID
        WKPennLogin.redirectURI = redirectURI
    }
    
    public static var isLoggedIn: Bool {
        WKPennNetworkManager.instance.hasRefreshToken()
    }
    
    public static func logout() {
        WKPennNetworkManager.instance.clearRefreshToken()
    }
}
