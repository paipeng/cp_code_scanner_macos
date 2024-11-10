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
    
    
    open func setUser(user: RestApi.Types.Response.User) {
        defaults.set(user, forKey: "USER")
    }
    
    open func getUser() -> RestApi.Types.Response.User? {
        let user = defaults.object(forKey: "USER")
        if user != nil {
            return user as? RestApi.Types.Response.User
            /*
            do {
                //print("response data: " + str!)
                let result = try JSONDecoder().decode(RestApi.Types.Response.User.self, from: str!.data(using: .utf8)!)
                
                return result
            } catch {
                print("Decode failed: \(error)")
                return nil
            }
             */
        } else {
            return nil
        }
    }
    
    open func getToken() -> String? {
        if (getUser() != nil) {
            let user:RestApi.Types.Response.User  = getUser()!
            return user.token
        } else {
            return nil
        }
    }
}
