//
//  SelectedSection.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

public enum SelectedSection: Int, Codable {
    
    case today
    case week
    case tasks
    
    enum CodingKeys: CodingKey {
        case rawValue
    }
}

struct SelectedSectionHolder: Codable {
        
    var selectedSection: SelectedSection?
    
    init(selectedSection: SelectedSection? = nil) {
        self.selectedSection = selectedSection
    }
}

extension SelectedSectionHolder: RawRepresentable, Hashable {
    public init?(rawValue: Int) {
        selectedSection = SelectedSection(rawValue: rawValue)
    }

    public var rawValue: Int {
        return selectedSection?.rawValue ?? 0
    }
}
