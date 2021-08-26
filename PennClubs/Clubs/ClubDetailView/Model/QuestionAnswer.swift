//
//  QuestionAnswer.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 24/7/2021.
//

import Foundation

struct QuestionAnswer: Codable, Identifiable {
    let id: Int
    let question: String
    let answer: String?
    let author: String
    let responder: String
    let approved: Bool
}
