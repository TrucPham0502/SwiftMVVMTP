//
//  ApiResponseDto.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
protocol ApiResponseDtoType {
    associatedtype Element : Codable
    var returnCode: ReturnCode? { get }
    var returnMessage: String? { get }
    var data: Element? { get }
}
struct ApiResponseDto<Element: Codable>: Codable, ApiResponseDtoType {
    let returnCode: ReturnCode?
    let returnMessage: String?
    let data: Element?

    enum CodingKeys: String, CodingKey {
        case returnCode = "ReturnCode"
        case returnMessage = "ReturnMessage"
        case data = "Data"
    }
}

enum ReturnCode : Int
{
    case success = 1
    case fail = -2
    case expired = -1
    case unknown
}
extension ReturnCode: Codable {
    public init(from decoder: Decoder) throws {
        self = try ReturnCode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
