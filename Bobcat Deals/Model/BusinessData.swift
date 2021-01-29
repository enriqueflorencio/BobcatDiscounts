//
//  BusinessData.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/1/20.
//

import Foundation

public struct businessData: Codable {
    public var data: businesses
}

public struct businesses: Codable {
    public var businesses: [businessInfo]
}

public struct businessInfo: Codable {
    public var businessName: String?
    public var businessImageURL: String?
    public var itemImageURL: String?
    public var description: String?
    public var address: String?
    public var latitude: Double?
    public var longitude: Double?
    public var category: String?
}
