//
//  SocialManager.swift
//  anytime
//
//  Created by NhatQuang on 2/11/18.
//

import Foundation
import UIKit
import SwiftyJSON
//import FacebookCore
//import FacebookLogin
//import FacebookShare
//import LineSDK
//import SwiftInstagram
//import TwitterKit
//import GoogleSignIn
//import ZaloSDK
//import Firebase
import RxCocoa
import RxSwift

enum SocialType: Int {
    
    case none = 0
    case facebook = 1
    case instagram = 2
    case twitter = 3
    case line = 4
    case anonymous = 5
    case google = 6
    case zalo = 7
    
    var stringName: String {
        switch self {
        case .facebook:
            return "Facebook"
        case .instagram:
            return "Instagram"
        case .twitter:
            return "Twitter"
        case .line:
            return "Line"
        case .google:
            return "Google"
        case .zalo:
            return "Zalo"
        default:
            return "Anonymous"
        }
    }
    
    init?(rawString: String) {
        switch rawString.lowercased() {
        case "facebook":
            self.init(rawValue: 1)
        case "instagram":
            self.init(rawValue: 2)
        case "twitter":
            self.init(rawValue: 3)
        case "line":
            self.init(rawValue: 4)
        default:
            self.init(rawValue: 5)
        }
    }
}

enum GenderType: Int {
    
    case male = 1
    case female = 2
    case neither = 0
    
    init?(rawString: String) {
        switch rawString.lowercased() {
        case "neither", "どちらでもない":
            self.init(rawValue: 0)
        case "male", "男性":
            self.init(rawValue: 1)
        case "female", "女性":
            self.init(rawValue: 2)
        default:
            self.init(rawValue: 0)
        }
    }
    
    var stringJP: String {
        switch self {
        case .neither:
            return "その他"
        case .male:
            return "男性"
        case .female:
            return "女性"
        }
    }
    
    var stringEN: String {
        switch self {
        case .neither:
            return "neither"
        case .male:
            return "male"
        case .female:
            return "female"
        }
    }
}

public struct PSocialUser {

    public var userId: String
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    public var fullName: String?
    public var profileURL: URL?
    public var gender: String?
    public var birthday: String?
    public var homeTown: String?
    public var email: String?
    public var authTokenSecret: String?
    
    public init(userId: String,
                firstName: String? = nil,
                middleName: String? = nil,
                lastName: String? = nil,
                fullName: String? = nil,
                profileURL: URL? = nil,
                gender: String? = nil,
                birthday: String? = nil,
                homeTown: String? = nil,
                email: String? = nil,
                authTokenSecret: String? = nil) {
        self.userId = userId
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.fullName = fullName
        self.profileURL = profileURL
        self.gender = gender
        self.birthday = birthday
        self.homeTown = homeTown
        self.email = email
        self.authTokenSecret = authTokenSecret
    }
}

enum PSocialLoginResult {
    case success(token: String, userProfile: PSocialUser?)
    case failed(code: Int, data: Any)
}

class SocialManager: NSObject {
	
	static let shared = SocialManager()
	
	typealias LoginResultHandle = (PSocialLoginResult?) -> Void
    typealias LogoutResultHandle = (Int, String?) -> Void
	typealias SearchResult = (Bool, JSON?) -> Void
    typealias ShareResultHandle = (Int, String?) -> Void
    
	var googleLoginResult: LoginResultHandle?
    
    var lineLoginResult: LoginResultHandle?
    var lineSearchResult: SearchResult?
    
    var shareResult: ShareResultHandle?
}

// MARK: - FACEBOOK

//extension SocialManager {
//
//    /// Refer link below
//    /// https://developers.facebook.com/docs/ios/getting-started/
//    /// https://developers.facebook.com/tools/explorer/
//    /// - Parameters:
//    ///   - viewcontroller: from UIViewController
//    ///   - result: result object
//    func loginFacebook(from viewcontroller: UIViewController, result: @escaping LoginResultHandle) {
//        let loginManager = LoginManager()
//        loginManager.logOut()
//        loginManager.logIn(readPermissions: [.publicProfile, .email, .userBirthday, .userGender, .userHometown], viewController: viewcontroller) { (loginResult) in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//                result(.failed(code: 0, data: error.localizedDescription))
//            case .cancelled:
//                print("User cancelled login.")
//                result(.failed(code: 0, data: LANGTEXT(key: "User cancelled login.")))
//            case .success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinedPermissions, token: let accessToken):
//                print("Logged in! \(grantedPermissions) \(declinedPermissions)")
//                print("AccessToken: \(accessToken.authenticationToken)")
//                let fbToken = accessToken.authenticationToken
//                UserProfile.loadCurrent({ (data) in
//                    guard let currentUser = UserProfile.current else {
//                        return
//                    }
//                    let user = PSocialUser(userId: currentUser.userId,
//                                            firstName: currentUser.firstName,
//                                            middleName: currentUser.middleName,
//                                            lastName: currentUser.lastName,
//                                            fullName: currentUser.fullName,
//                                            profileURL: currentUser.profileURL)
//                    result(.success(token: fbToken, userProfile: user))
//                })
//            }
//        }
//    }
//
//    func loginFacebook(from viewController: UIViewController) -> Observable<(fbToken: String, fbID: String)> {
//        return Observable.create { [weak viewController] observer -> Disposable in
//            guard let viewController = viewController else { return Disposables.create() }
//            let loginManager = LoginManager()
//            loginManager.logOut()
//            loginManager.logIn(readPermissions: [.publicProfile, .email, .userBirthday, .userGender, .userHometown, .userPosts], viewController: viewController) { (loginResult) in
//                switch loginResult {
//                case .failed(let error):
//                    print(error)
//                    observer.onError(error)
//                case .cancelled:
//                    print("User cancelled login.")
//                    observer.onCompleted()
//                case .success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinedPermissions, token: let accessToken):
//                    print("Logged in! \(grantedPermissions) \(declinedPermissions)")
//                    print("AccessToken: \(accessToken.authenticationToken)")
//                    let fbToken = accessToken.authenticationToken
//                    UserProfile.loadCurrent({ (profile) in
//                        guard let currentUser = UserProfile.current else {
//                            return
//                        }
//                        print("Profile Id: \(currentUser.userId)")
//                        observer.onNext((fbToken: fbToken, fbID: currentUser.userId))
//                        observer.onCompleted()
//                    })
//                }
//            }
//            return Disposables.create()
//        }
//    }
//
//    func facebookLogout(result: @escaping LogoutResultHandle) {
//        let loginManager = LoginManager()
//        loginManager.logOut()
//        result(1, nil)
//    }
//
//    // Graph search user information
//    // listField: ("id, email, first_name, last_name, name, gender, birthday, picture.type(large)")
//    // Reference: https://developers.facebook.com/docs/graph-api/reference/user
//
//    func graphSearchUserInformation(listField: String, searchResult: @escaping SearchResult) {
//        guard let accessToken = AccessToken.current else {
//            searchResult(false, nil)
//            return
//        }
//
//        let request = GraphRequest(graphPath: "me", parameters: ["fields": listField], accessToken: accessToken, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
//        // Search
//        request.start { (response, result) in
//            switch result {
//            case .success(let value):
//                var dictValue = value.dictionaryValue ?? [:]
//                dictValue["AccessToken"] = accessToken.authenticationToken
//                let info = JSON(dictValue)
//                searchResult(true, info)
//            case .failed(let error):
//                searchResult(false, nil)
//                print(error)
//            }
//        }
//    }
//
//    func graphSearchUserInformation(listField: String) -> Observable<(JSON?)> {
//        return Observable<JSON?>.create { observer -> Disposable in
//            self.graphSearchUserInformation(listField: listField, searchResult: { (result, jsonData) in
//                if result {
//                    observer.onNext(jsonData)
//                    observer.onCompleted()
//                } else {
//                    observer.onError(NSError())
//                }
//            })
//            return Disposables.create()
//        }
//    }
//
//    func facebookShareContent(survey: PReceiptModel) {
//        if let url = URL(string: "https://developers.facebook.com") {
//            let myContent = LinkShareContent(url: url)
//            let sharer = GraphSharer(content: myContent)
//            sharer.failsOnInvalidData = true
//            sharer.completion = { result in
//                // Handle share results
//            }
//            do {
//                try sharer.share()
//            } catch {
//                print("Error share link")
//            }
//        }
//    }
//}


//// MARK: - GOOGLE
//extension SocialManager {
//
//    func setupGoogleSignIn() {
//        GIDSignIn.sharedInstance().clientID = kGoogleClientID
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//    }
//
//    /// Refer link below
//    /// https://developers.google.com/identity/sign-in/ios/start-integrating
//    ///
//    /// - Parameter result: result object
//    func googleLogin(result: @escaping LoginResultHandle) {
//        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().signIn()
//        self.googleLoginResult = result
//        // then get user's profile
//        //let currentUser = GIDSignIn.sharedInstance().currentUser
//    }
//
//    func googleLogout(result: @escaping LogoutResultHandle) {
//        GIDSignIn.sharedInstance().signOut()
//        result(1, nil)
//    }
//}
//
//// MARK: - Google sign in delegate
//extension SocialManager: GIDSignInDelegate, GIDSignInUIDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error == nil {
//            var userModel = PSocialUser(userId: user.userID)
//            userModel.fullName = user.profile.name
//            userModel.email = user.profile.email
//            userModel.profileURL = user.profile.imageURL(withDimension: 120)
//            //print("google token: \(user.authentication.accessToken)")
//            self.googleLoginResult?(.success(token: user.authentication.accessToken, userProfile: userModel))
//        } else {
//            self.googleLoginResult?(.failed(code: 0, data: error.localizedDescription))
//        }
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        self.googleLoginResult?(.failed(code: 0, data: error.localizedDescription))
//    }
//
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        //self.present(viewController, animated: true, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        //self.dismiss(animated: true, completion: nil)
//    }
//}

// MARK: - Zalo SDK
//extension SocialManager {
//
//    /// Refer link below
//    /// https://developers.zalo.me/docs/sdk/ios-sdk-9
//    ///
//    /// - Parameter result: result obejct
//    func zaloLogin(result: @escaping LoginResult) {
//        ZaloSDK.sharedInstance().unauthenticate()
//        ZaloSDK.sharedInstance().isAuthenticatedZalo { (response) in
//            if response?.errorCode == Int(kZaloSDKErrorCodeNoneError.rawValue) {
//                let oauthCode = response?.oauthCode
//                result(.success(token: oauthCode, userProfile: nil))
//            } else {
//                ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: self) { (response) in
//                    if (response?.isSucess)! {
//                        let oauthCode = response?.oauthCode
//                        //print("authen: \(oauthCode)")
//                        result(.success(token: oauthCode, userProfile: nil))
//                    } else if response?.errorCode != Int(kZaloSDKErrorCodeUserCancel.rawValue) {
//                        _ = EZAlertController.alert(LANGTEXT(key: "Lỗi"), message: response?.errorMessage ?? LANGTEXT(key: "Không thể đăng nhập Zalo"))
//                        result(.failed(code: 0, data: response?.errorMessage ?? LANGTEXT(key: "Không thể đăng nhập Zalo")))
//                    }
//                }
//            }
//        }
//    }
//
//    func zaloGetUserProfile(searchResult: @escaping SearchResult) {
//        ZaloSDK.sharedInstance().getZaloUserProfile(callback: { (response) in
//            if response?.errorCode == Int(kZaloSDKErrorCodeNoneError.rawValue) {
//                let info = JSON(response?.data ?? [:])
//                searchResult(true, info)
//            } else {
//                print(response.errorMessage)
//                searchResult(false, nil)
//            }
//        })
//    }
//
//    func zaloLogout(result: @escaping LogoutResultHandle) {
//        ZaloSDK.sharedInstance().unauthenticate()
//        result(1, nil)
//    }
//}

// MARK: - Line SDK

//extension SocialManager {
//
//    /// refer link below
//    /// https://developers.line.me/console/
//    /// https://developers.line.me/en/docs/ios-sdk/
//    /// - Parameter result: result object
//    func lineLogin(result: @escaping LoginResultHandle) {
//        let apiClient = LineSDKAPI.init(configuration: LineSDKConfiguration.defaultConfig())
//        apiClient.logout(queue: DispatchQueue.main) { (success, error) in
//            // write code here
//        }
//        LineSDKLogin.sharedInstance().delegate = self
//        LineSDKLogin.sharedInstance().start()
//        self.lineLoginResult = result
//    }
//
//    func lineLogout(result: @escaping LogoutResultHandle) {
//        let apiClient = LineSDKAPI.init(configuration: LineSDKConfiguration.defaultConfig())
//        apiClient.logout(queue: DispatchQueue.main) { (success, error) in
//            if success {
//                result(1, nil)
//            } else {
//                if let error = error {
//                    print("Line Logout Failed: \(error.localizedDescription)")
//                    result(0, error.localizedDescription)
//                }
//            }
//        }
//    }
//
//    func lineGetUserProfile(searchResult: @escaping SearchResult) {
//        let apiClient = LineSDKAPI.init(configuration: LineSDKConfiguration.defaultConfig())
//        apiClient.getProfile(queue: DispatchQueue.main) { (profile, error) in
//            if let _ = error {
//                searchResult(false, nil)
//            } else if let profile = profile {
//                let profileJSON = JSON(["displayName": profile.displayName,
//                                        "userID": profile.userID,
//                                        "statusMessage": profile.statusMessage,
//                                        "pictureURL": profile.pictureURL?.absoluteString])
//                searchResult(true, profileJSON)
//            }
//        }
//    }
//}

// MARK: - LineSDKLoginDelegate

//extension SocialManager: LineSDKLoginDelegate {
//
//    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
//        if let error = error {
//            // Login failed with an error. Use the error parameter to identify the problem.
//            print("Line login error: \(error.localizedDescription)")
//            self.lineLoginResult?(.failed(code: 0, data: error.localizedDescription))
//        } else {
//            // Login success. Extracts the access token, user profile ID, display name, status message, and profile picture.
//            if let profile = profile {
//                let user = PSocialUser(userId: profile.userID,
//                                       firstName: nil,
//                                       middleName: nil,
//                                       lastName: nil,
//                                       fullName: profile.displayName,
//                                       profileURL: profile.pictureURL)
//                self.lineLoginResult?(.success(token: credential?.accessToken?.accessToken ?? "", userProfile: user))
//            }
//        }
//    }
//}

// MARK: - Instagram SDK

//extension SocialManager {
//
//    /// refer link below
//    /// https://www.instagram.com/developer/clients/manage/
//    /// https://github.com/AnderGoig/SwiftInstagram
//    /// - Parameters:
//    ///   - naviController: navi object
//    ///   - result: result object
//    func instagramLogin(from naviController: UINavigationController, result: @escaping LoginResultHandle) {
//        //let url = URL(string: "https://api.instagram.com/oauth/authorize?client_id=dce642caa1a840ca861ad0040408f854&redirect_uri=http://paditech.com&response_type=token&scope=basic")
//        let webView = InstagramLoginVC(success: { (accessToken) in
//            naviController.popViewController(animated: true)
//            result(.success(token: accessToken, userProfile: nil))
//        }) { (error) in
//            naviController.popViewController(animated: true)
//            result(.failed(code: 0, data: error.localizedDescription))
//        }
//        naviController.show(webView, sender: nil)
//
//        /*
//        let api = Instagram.shared
//        api.logout()
//        api.login(from: naviController, success: {
//            api.user("self", success: { (profile) in
//                let user = PSocialUser(userId: profile.id,
//                                       fullName: profile.fullName,
//                                       profileURL: profile.profilePicture)
//                result(.success(token: api.retrieveAccessToken() ?? "", userProfile: user))
//            }, failure: { (error) in
//                result(.failed(code: 0, data: error.localizedDescription))
//            })
//        }) { (error) in
//            result(.failed(code: 0, data: error.localizedDescription))
//        }
//        */
//    }
//
//    func instagramLogout(result: @escaping LogoutResultHandle) {
//        let api = Instagram.shared
//        if api.logout() {
//            result(1, nil)
//        } else {
//            result(0, LANGTEXT(key: "An error occurred, please try again"))
//        }
//    }
//
//    func instagramShareContent(survey: PReceiptModel, completion: @escaping ShareResultHandle) {
//        if let instagramURL = URL(string: "instagram://tag?name=TAG") {
//            if UIApplication.shared.canOpenURL(instagramURL) {
//                UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
//            }
//        }
//    }
//}

// MARK: - Twitter SDK

//extension SocialManager {
//
//    /// refer link below
//    /// https://github.com/twitter/twitter-kit-ios
//    ///
//    /// - Parameter result: result object
//    func twitterLogin(result: @escaping LoginResultHandle) {
//        let store = TWTRTwitter.sharedInstance().sessionStore
//        if let userID = store.session()?.userID {
//            store.logOutUserID(userID)
//        }
//
//        TWTRTwitter.sharedInstance().logIn { (session, error) in
//            if let session = session {
//                print(session)
//                let client = TWTRAPIClient.withCurrentUser()
//                client.loadUser(withID: session.userID, completion: { (user, error) in
//                    if let user = user {
//                        // get original avatar
//                        let pathExtension = URL(string: user.profileImageURL)?.pathExtension ?? ""
//                        let originalAvatar = user.profileImageURL.substring(to: user.profileImageURL.count - "_normal.jpg".count) + (pathExtension.count > 0 ? ".\(pathExtension)" : "")
//                        var existOriginalAvatar = false
//                        if let originalAvatarUrl = URL(string: originalAvatar) {
//                            existOriginalAvatar = UIApplication.shared.canOpenURL(originalAvatarUrl)
//                        }
//                        let userProfile = PSocialUser(userId: session.userID,
//                                               fullName: user.name,
//                                               profileURL: URL(string: existOriginalAvatar ? originalAvatar : user.profileImageLargeURL),
//                                               authTokenSecret: session.authTokenSecret)
//                        result(.success(token: session.authToken, userProfile: userProfile))
//                    } else if let error = error {
//                        print("Twitter get profile error: \(error.localizedDescription)")
//                        self.lineLoginResult?(.failed(code: 0, data: error.localizedDescription))
//                    }
//                })
//            } else if let error = error {
//                print("Twitter login error: \(error.localizedDescription)")
//                self.lineLoginResult?(.failed(code: 0, data: error.localizedDescription))
//            }
//        }
//    }
//
//    func twitterLogout(result: @escaping LogoutResultHandle) {
//        let store = TWTRTwitter.sharedInstance().sessionStore
//        if let userID = store.session()?.userID {
//            store.logOutUserID(userID)
//            result(1, nil)
//        } else {
//            result(0, LANGTEXT(key: "An error occurred, please try again"))
//        }
//    }
//
//    func twitterShareContent(survey: PReceiptModel, completion: @escaping ShareResultHandle) {
//        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
//            createDynamicLink(survey: survey) { (code, data) in
//                if code == 1 {
//                    // Create the composer
//                    let composerVC = TWTRComposerViewController(initialText: (data as? URL)?.absoluteString ?? "", image: nil, videoURL: nil)
//                    composerVC.delegate = self
//                    self.shareResult = completion
//                    UIApplication.topVC()?.present(composerVC, animated: true, completion: nil)
//                }
//            }
//        } else {
//            self.twitterLogin { (loginResult) in
//                if let result = loginResult {
//                    switch result {
//                    case .success(_, _):
//                        self.twitterShareContent(survey: survey, completion: { (code, message) in
//                            // write code here
//                        })
//                        break
//                    case .failed(_, let data):
//                        let message = (data as? String) ?? LANGTEXT(key: "No Twitter Accounts Available. /nYou must log in before presenting a composer.")
//                        completion(0, message)
//                        break
//                    }
//                }
//            }
//        }
//    }
//}

// MARK: - TWTRComposerViewControllerDelegate

//extension SocialManager: TWTRComposerViewControllerDelegate {
//
//    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
//        self.shareResult?(0, error.localizedDescription)
//    }
//
//    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
//        self.shareResult?(1, LANGTEXT(key: "Share the survey successfully"))
//    }
//}

// MARK: - Firebase SDK

//extension SocialManager {
//
//    func createDynamicLink(survey: PReceiptModel, completion: @escaping ((Int, Any) -> Void)) {
//        guard let link = URL(string: "https://supership.com?surveyId=\(survey.id)") else { return }
//        let dynamicLinksDomain = "supership.page.link"
//        let linkBuilder = DynamicLinkComponents(link: link, domain: dynamicLinksDomain)
//        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.paditech.supership")
//        //linkBuilder.iOSParameters?.appStoreID = "1435877164"
//        //linkBuilder.iOSParameters?.minimumAppVersion = "1.0"
//        //linkBuilder.iOSParameters?.customScheme = "com.supership.app"
//        //linkBuilder.iOSParameters?.fallbackURL = nil
//
//        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.paditech.supership")
//        //linkBuilder.androidParameters?.minimumVersion = 10
//        //linkBuilder.androidParameters?.fallbackURL = nil
//
//        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
//        linkBuilder.socialMetaTagParameters?.title = survey.title
//        linkBuilder.socialMetaTagParameters?.descriptionText = "アンケートに答えるだけで\n 賞金\(Double(survey.buget).currencyJPText)山分け！"
//        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: survey.image)
//
//        linkBuilder.shorten() { url, warnings, error in
//            if let url = url {
//                completion(1, url)
//            } else if let error = error {
//                completion(0, error.localizedDescription)
//            }
//        }
//    }
//}

// MARK: - UIActivityViewController

//extension SocialManager {
//
//    /// share content with all social networking in UIActivityViewController
//    ///
//    /// - Parameters:
//    ///   - survey: survey object
//    ///   - completion: completion closure
//    func shareAllSocial(survey: PReceiptModel, image: UIImage? = nil, includedActivityTypes: [UIActivityType]? = nil, completion: @escaping ShareResultHandle) {
//        if let topVC = UIApplication.topVC() {
//            createDynamicLink(survey: survey) { (code, data) in
//                if code == 1 {
//                    let shareManager = ShareManager(sourceViewController: topVC)
//                    var contents: [Any] = []
//                    if let image = image {
//                        contents = ["アンケートに答えるだけで\n 賞金\(Double(survey.buget).currencyJPText)山分け！", data, image]
//                    } else {
//                        contents = ["アンケートに答えるだけで\n 賞金\(Double(survey.buget).currencyJPText)山分け！", data]
//                    }
//                    shareManager.share(contents: contents, includedActivityTypes: includedActivityTypes, completion: { (code, message) in
//                        completion(code, message)
//                    })
//                } else {
//                    completion(0, (data as? String) ?? "")
//                }
//            }
//        }
//    }
//}
























