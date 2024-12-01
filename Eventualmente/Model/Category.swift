//
//  Category.swift
//  Eventualmente
//
//  Created by Inés Carrión on 1/12/24.
//

import Foundation
import FirebaseFirestore

struct Category: Codable, Hashable {
    @DocumentID var id: String?

    let name: String
    let subcategories: [String]
}
