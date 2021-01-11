//
//  SessionState.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 1/8/21.
//

import Foundation
public enum SessionState: Int {
    case running
    case suspended
    case canceling
    case completed
}
