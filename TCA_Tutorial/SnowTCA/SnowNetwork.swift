//
//  SnowNetwork.swift
//  TCA_Tutorial
//
//  Created by Daeho Park on 6/1/25.
//

import Foundation

protocol SnowNetworkService {
  func fetchFact(_ count: Int) async throws -> String
}

final class SnowNetwork: SnowNetworkService {
  func fetchFact(_ count: Int) async throws -> String {
    let (data, _) = try await URLSession.shared
      .data(from: URL(string: "http://numbersapi.com/\(count)")!)
    return String(decoding: data, as: UTF8.self)
  }
}
