//
//  RxKingfisherError.swift
//  RxKingfisher
//
//  Created by Shai Mishali on 5/5/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import Foundation

enum RxKingfisherError: Swift.Error {
    case kingfisherError(NSError)
    case missingImage
}
