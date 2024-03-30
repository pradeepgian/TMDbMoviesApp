//
//  ViewModelUtilities.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import Foundation

enum ScreenState: Equatable {
    
    case idle
    case loading
    case complete
    case error(Error)
    
    static func == (lhs: ScreenState, rhs: ScreenState) -> Bool {
        switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.complete, .complete):
                return true
            case let (.error(lhsError), .error(rhsError)):
                // Compare the associated errors if both cases are .error
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
        }
    }
}

protocol ViewModelProtocol {}

protocol ConfigureDataInViewProtocol {
    func updateDataInView(from viewModel: ViewModelProtocol)
}

