//
//  PreviewImageViewModel.swift
//  headling
//
//  Created by NhatQuang on 5/17/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PreviewImageViewModel {
	
	let disposeBag = DisposeBag()
    var imageLink = Variable<String>("")
    var title = Variable<String?>(nil)
    var description = Variable<String?>(nil)
	var heroImageID: String? 
	
    convenience init(imageLink: String, title: String? = nil, description: String? = nil) {
		self.init()
        
		self.imageLink.value = imageLink
        self.title.value = title
        self.description.value = description
	}
}
