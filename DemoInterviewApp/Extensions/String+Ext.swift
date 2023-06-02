//
//  String+Ext.swift
//  DemoInterviewApp
//
//  Created by Aykhan Hajiyev on 02.06.23.
//

import Foundation

extension String {
    
    func applyPatternOnNumbers(regex: String, mask: String, replacmentCharacter: Character) -> String {
        let pureNumber = replacingOccurrences(of: regex, with: "", options: .regularExpression)
        var result = ""
        var pureNumberIndex = pureNumber.startIndex
        for patternCharacter in mask {
            guard pureNumberIndex < pureNumber.endIndex else { return result }
            if patternCharacter == replacmentCharacter {
                result.append(pureNumber[pureNumberIndex])
                pureNumber.formIndex(after: &pureNumberIndex)
            } else {
                result.append(patternCharacter)
            }
        }
        return result
    }
    
    func textPattern(regex: String = "[^0-9]", mask: String = "#### #### #### ####") -> String {
        applyPatternOnNumbers(regex: regex, mask: mask, replacmentCharacter: "#")
    }
}
