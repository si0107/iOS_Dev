//
//  String+AddText.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//

import Foundation

extension String {
  mutating func add(
    text: String?,
    separatedBy separator: String = ""
  ) {
    if let text = text {
      if !isEmpty {
        self += separator
      }
      self += text
    }
  }
}
