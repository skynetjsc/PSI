//
//  JsonHelper.swift
//  anecel
//
//  Created by NhatQuang on 6/6/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonHelper {
	
	static let shared = JsonHelper()
	
	func readFile(name jsonFileName: String) -> JSON {
		let jsonPath = Bundle.main.path(forResource: jsonFileName, ofType: "json")
		let jsonData = JSON(NSData(contentsOfFile: jsonPath!)!)
		return jsonData
	}
}

// MARK: - Helper

extension JsonHelper {
    
//    func listLocation() -> [PLocationModel] {
//        let locationJSON = self.readFile(name: "locations")
//        return locationJSON.arrayValue.map { PLocationModel(json: $0) }
//    }
//
//    func listHiragana() -> [PHiraganaModel] {
//        let hiraganaJSON = self.readFile(name: "japanese")
//        return hiraganaJSON.arrayValue.map { PHiraganaModel(json: $0) }
//    }
}






