//
//  TabViewUtilities.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import Foundation

enum TabItem: String, CaseIterable {
    case popular
    case latest
    
    var title: String {
        switch self {
            case .popular: return "Popular"
            case .latest: return "Latest"
        }
    }
    
    var imageName: String {
        switch self {
            case .popular: return "Popular"
            case .latest: return "PlayingNow"
        }
    }
}

protocol TabBarPresentable {
    var tabProperties: TabItem { get }
}

