//
//  Defaults.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 2/11/22.
//

import UIKit
import Foundation

struct Defaults {
    
    struct URL {
        
        static var host: Foundation.URL  = .init(string: "https://script.google.com/").forceUnwrapped
        
        static var macros: Foundation.URL { host.appendingPathComponent("macros/s/AKfycbzNPN95_VIeYPTKF85yVS5oml_lUiVL0TUlQvuNj1krEUjUQFtBq_BY6eraap6zW2ZI/exec") }
        
        enum Component {
            enum Key: String {
                case page = "page"
                case tab = "tab"
                case cinema_id = "cinema_id"
                case movie_id = "movie_id"
                case type = "type"
            }
            enum Value: String {
                case page = ""
            }
        }
    }
}
