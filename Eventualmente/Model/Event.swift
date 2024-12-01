//
//  Event.swift
//  Eventualmente
//
//  Created by Inés Carrión on 30/11/24.
//
import SwiftUI
import FirebaseFirestore

struct Event: Codable {
    @DocumentID var id: String?

    let userId: String?
    var isPublic: Bool {
        userId == nil
    }

    let title: String
    let categoryName: String?
    let subcategoryName: String?
    let location: String?
    let date: Date
    let link: String?
    let moreInfo: String?
}
