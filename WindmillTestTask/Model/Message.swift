//
//  Message.swift
//  WindmillTestTask
//
//  Created by Alex2 on 5/7/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

struct Message: Decodable {
    let fromName: String?
    let toNames: [String]?
    let ccNames: [String]?
    let messageDate: Date?
    let subject: String?
    let description: String?
    let importanceLevel: Int?
    let isRead: Bool?
    let isPinned: Bool?
}
