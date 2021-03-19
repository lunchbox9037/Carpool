//
//  SearchableRecordDelegate.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import Foundation

// MARK: - Protocol
protocol SearchableRecordDelegate {
    func matches(searchTerm: String, username: String) -> Bool
}

extension SearchableRecordDelegate {
    func matches(searchTerm: String, username: String) -> Bool{
        if username.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            return false
        }
    }
}
