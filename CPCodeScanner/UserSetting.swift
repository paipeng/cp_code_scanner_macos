//
//  UserSetting.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 10.11.24.
//

import Foundation
import HtwmRestful


class UserSetting {
    let defaults = UserDefaults.standard
    
    
    open func setUsernamePassword(username: String?, password: String?) {
        defaults.set(username, forKey: "USERNAME")
        defaults.set(password, forKey: "PASSWORD")
    }
    
    open func getUsername() -> String? {
        return defaults.string(forKey: "USERNAME")
    }
    
    open func getPassword() -> String? {
        return defaults.string(forKey: "PASSWORD")
    }
    
    
    open func setToken(token: String?) {
        defaults.set(token, forKey: "TOKEN")
        
    }
    
    
    open func getToken() -> String? {
        return defaults.string(forKey: "TOKEN")
    }
}
