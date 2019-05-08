//
//  CsvHelper.swift
//  Receigo
//
//  Created by Mac on 12/11/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import SwiftyJSON
//import SwiftCSV

class CsvHelper {
    
    static let shared = CsvHelper()
    
    func readFile(name csvFileName: String) -> CSV? {
        do {
            let jsonPath = Bundle.main.path(forResource: csvFileName, ofType: "csv")
            let csv = try CSV(name: jsonPath!)
            
            return csv
        } catch let error {
            print(error)
            return nil
        }
    }
}

// MARK: - Helper

extension CsvHelper {
    
//    func listBanks() -> [PBankModel] {
//        let bankCsv = self.readFile(name: "banks")
//        guard let csv = bankCsv  else { return [] }
//        
//        var results = [PBankModel]()
//        csv.enumerateAsArray { (array) in
//            //print(array)
//            let bank = PBankModel(array: array)
//            results.append(bank)
//        }
//        
//        return results
//    }
}
