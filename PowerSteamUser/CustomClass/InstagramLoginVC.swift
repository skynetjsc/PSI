//
//  InstagramLoginVC.swift
//  Supership
//
//  Created by Mac on 1/8/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import UIKit
import WebKit

public enum InstagramScope: String {
    
    /// To read a user’s profile info and media.
    case basic
    
    /// To read any public profile info and media on a user’s behalf.
    case publicContent = "public_content"
    
    /// To read the list of followers and followed-by users.
    case followerList = "follower_list"
    
    /// To post and delete comments on a user’s behalf.
    case comments
    
    /// To follow and unfollow accounts on a user’s behalf.
    case relationships
    
    /// To like and unlike media on a user’s behalf.
    case likes
    
    /// To get all permissions.
    case all = "basic+public_content+follower_list+comments+relationships+likes"
}

extension Array where Element == InstagramScope {
    
    /// Returns a String constructed by joining the array elements with the given `separator`.
    func joined(separator: String) -> String {
        return self.map { "\($0.rawValue)" }.joined(separator: separator)
    }
}

public enum InstagramError: Error {
    
    /// Error 400 on login
    case badRequest
    
    /// Error decoding JSON
    case decoding(message: String)
    
    /// Invalid API request
    case invalidRequest(message: String)
    
    /// Keychain error
    case keychainError(code: OSStatus)
    
    /// The client id or the redirect URI is missing inside the Info.plist file
    case missingClientIdOrRedirectURI
}

class InstagramLoginVC: UIViewController {
    
    // MARK: - Types
    
    typealias SuccessHandler = (_ accesToken: String) -> Void
    typealias FailureHandler = (_ error: InstagramError) -> Void
    
    private enum API {
        static let authURL = "https://api.instagram.com/oauth/authorize"
        static let baseURL = "https://api.instagram.com/v1"
    }
    
    // MARK: - Properties
    
    private var client: (id: String?, redirectURI: String?)?
    private var authURL: URL!
    private var success: SuccessHandler?
    private var failure: FailureHandler?
    
    private var progressView: UIProgressView!
    private var webViewObservation: NSKeyValueObservation!
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(success: SuccessHandler?, failure: FailureHandler?) {
        self.success = success
        self.failure = failure
        super.init(nibName: nil, bundle: nil)
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            let clientId = dict["InstagramClientId"] as? String
            let redirectURI = dict["InstagramRedirectURI"] as? String
            self.client = (clientId, redirectURI)
        }
        guard client != nil else { failure?(InstagramError.missingClientIdOrRedirectURI); return }
        
        let scopes: [InstagramScope] = [.basic]
        let authURL = self.buildAuthURL(scopes: scopes)
        self.authURL = authURL
    }
    
    private func buildAuthURL(scopes: [InstagramScope]) -> URL {
        var components = URLComponents(string: API.authURL)!
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: client!.id),
            URLQueryItem(name: "redirect_uri", value: client!.redirectURI),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: scopes.joined(separator: "+"))
        ]
        
        return components.url!
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        // Initializes progress view
        setupProgressView()
        
        // Initializes web view
        let webView = setupWebView()
        
        // Starts authorization
        webView.load(URLRequest(url: authURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }
    
    deinit {
        progressView.removeFromSuperview()
        webViewObservation.invalidate()
    }
    
    // MARK: -
    
    private func setupProgressView() {
        let navBar = navigationController!.navigationBar
        
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.0
        progressView.tintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.addSubview(progressView)
        
        let bottomConstraint = navBar.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 1)
        let leftConstraint = navBar.leadingAnchor.constraint(equalTo: progressView.leadingAnchor)
        let rightConstraint = navBar.trailingAnchor.constraint(equalTo: progressView.trailingAnchor)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint])
    }
    
    private func setupWebView() -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        
        webViewObservation = webView.observe(\.estimatedProgress, changeHandler: progressViewChangeHandler)
        
        view.addSubview(webView)
        
        return webView
    }
    
    private func progressViewChangeHandler<Value>(webView: WKWebView, change: NSKeyValueObservedChange<Value>) {
        progressView.alpha = 1.0
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        
        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.progressView.alpha = 0.0
            }, completion: { (_ finished) in
                self.progressView.progress = 0
            })
        }
    }
    
}

// MARK: - WKNavigationDelegate

extension InstagramLoginVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = webView.title
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urlString = navigationAction.request.url!.absoluteString
        
        guard let range = urlString.range(of: "#access_token=") else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        
        DispatchQueue.main.async {
            self.success?(String(urlString[range.upperBound...]))
        }
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let httpResponse = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(.allow)
            return
        }

        switch httpResponse.statusCode {
        case 400:
            decisionHandler(.cancel)
            DispatchQueue.main.async {
                self.failure?(InstagramError.badRequest)
            }
        default:
            decisionHandler(.allow)
        }
    }
}
