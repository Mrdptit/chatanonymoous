//
//  User.swift
//  KOFA
//
//  Created by may1 on 11/15/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class User: NSObject , NSCoding{
   
    
    var createdAt   :   String?    =   String()
    var nickname    :   String?    =   String()
    var user_name   :   String?    =   String()
    var facebook_id :   String?    =   String()
    var email       :   String?    =   String()
    var avatar      :   String?    =   String()
    var cover       :   String?    =   String()
    var birthday    :   String?    =   String()
    var carrier     :   String?    =   String()
    var city        :   String?    =   String()
    var country     :   String?    =   String()
    var country_code:   String?    =   String()
    var bundle_id   :   String?    =   String()
    var device_type :   String?    =   String()
    var device_id   :   String?    =   String()
    var device_token:   String?    =   String()
    var device_name :   String?    =   String()
    var wifi_name   :   String?    =   String()
    var ips         :   String?    =   String()
    var latitude    :   String?    =   String()
    var longtitude  :   String?    =   String()
    var calling_code:   String?    =   String()
    var phone_number:   String?    =   String()
    var access_token:   String?    =   String()
    var facebook_token:    String? =   String()
    var gender      :   Int?       =   Int()
    var idUser      :   Int?       =   Int()
    var point       :   Int?       =   Int()
    override init() {
        super.init()
    }
    init(dict : [String : AnyObject]) {
        createdAt       =   (dict[K_CreatedAt]  as? String) ??  ""
        nickname        =   (dict[K_NickName]   as? String) ??  ""
        user_name       =   (dict[K_UserName]   as? String) ??  ""
        facebook_id     =   (dict[K_FacebookID] as? String) ??  ""
        email           =   (dict[K_Email]      as? String) ??  ""
        avatar          =   (dict[K_Avatar]     as? String) ??  ""
        cover           =   (dict[K_Cover]      as? String) ??  ""
        birthday        =   (dict[K_Birthday]   as? String) ??  ""
        carrier         =   (dict[K_Carrier]    as? String) ??  ""
        city            =   (dict[K_City]       as? String) ??  ""
        country         =   (dict[K_Country]    as? String) ??  ""
        country_code    =   (dict[K_CountryCode]as? String) ??  ""
        bundle_id       =   (dict[K_BundelID]   as? String) ??  ""
        device_type     =   (dict[K_DeviceType] as? String) ??  ""
        device_id       =   (dict[K_DeviceID]   as? String) ??  ""
        device_token    =   (dict[K_DeviceToken]as? String) ??  ""
        device_name     =   (dict[K_DeviceName] as? String) ??  ""
        wifi_name       =   (dict[K_WifiName]   as? String) ??  ""
        ips             =   (dict[K_IPs]        as? String) ??  ""
        latitude        =   (dict[K_Latitude]   as? String) ??  ""
        longtitude      =   (dict[K_Longitude]  as? String) ??  ""
        calling_code    =   (dict[K_CallingCode]as? String) ??  ""
        phone_number    =   (dict[K_PhoneNumbe] as? String) ??  ""
        access_token    =   (dict[K_AccessToken]as? String) ??  ""
        facebook_token  =   (dict[K_FacebookToken]   as? String) ?? ""
        gender          =   (dict[K_Gender]     as? Int)    ??  1
        idUser          =   (dict[K_Id]        as? Int)     ??  0
        point           =   (dict[K_Point]        as? Int)     ??  0
        
        
    }
    required init(coder aDecoder: NSCoder) {
        if let nickname             = aDecoder.decodeObject(forKey: K_NickName) as? String {
            self.nickname           =   nickname
        }
        if let createdAt            = aDecoder.decodeObject(forKey: K_CreatedAt) as? String {
            self.createdAt           =   createdAt
        }
        if let user_name            = aDecoder.decodeObject(forKey: K_UserName) as? String {
            self.user_name          =   user_name
        }
        if let facebook_id          = aDecoder.decodeObject(forKey: K_FacebookID) as? String {
            self.facebook_id        =   facebook_id
        }
        if let email                = aDecoder.decodeObject(forKey: K_Email) as? String {
            self.email              =   email
        }
        if let avatar               = aDecoder.decodeObject(forKey: K_Avatar) as? String {
            self.avatar             =   avatar
        }
        if let cover                = aDecoder.decodeObject(forKey: K_Cover) as? String {
            self.cover              =   cover
        }
        if let birthday             = aDecoder.decodeObject(forKey: K_Birthday) as? String {
            self.birthday           =   birthday
        }
        if let carrier              = aDecoder.decodeObject(forKey: K_Carrier) as? String {
            self.carrier            =   carrier
        }
        if let city                 = aDecoder.decodeObject(forKey: K_City) as? String {
            self.city               =   city
        }
        if let country              = aDecoder.decodeObject(forKey: K_Country) as? String {
            self.country            =   country
        }
        if let country_code         = aDecoder.decodeObject(forKey: K_CountryCode) as? String {
            self.country_code       =   country_code
        }
        if let bundle_id            = aDecoder.decodeObject(forKey: K_BundelID) as? String {
            self.bundle_id          =   bundle_id
        }
        if let device_type          = aDecoder.decodeObject(forKey: K_DeviceType) as? String {
            self.device_type        =   device_type
        }
        if let device_name          = aDecoder.decodeObject(forKey: K_DeviceName) as? String {
            self.device_name        =   device_name
        }
        if let device_id            = aDecoder.decodeObject(forKey: K_DeviceID) as? String {
            self.device_id          =   device_id
        }
        if let device_token         = aDecoder.decodeObject(forKey: K_DeviceToken) as? String {
            self.device_token       =   device_token
        }
        if let wifi_name            = aDecoder.decodeObject(forKey: K_WifiName) as? String {
            self.wifi_name          =   wifi_name
        }
        if let ips                  = aDecoder.decodeObject(forKey: K_IPs) as? String {
            self.ips                =   ips
        }
        if let latitude             = aDecoder.decodeObject(forKey: K_Latitude) as? String {
            self.latitude           =   latitude
        }
        if let longtitude           = aDecoder.decodeObject(forKey: K_Longitude) as? String {
            self.longtitude         =   longtitude
        }
        if let calling_code         = aDecoder.decodeObject(forKey: K_CallingCode) as? String {
            self.calling_code       =   calling_code
        }
        if let phone_number         = aDecoder.decodeObject(forKey: K_PhoneNumbe) as? String {
            self.phone_number       =   phone_number
        }
        if let access_token         = aDecoder.decodeObject(forKey: K_AccessToken) as? String {
            self.access_token       =   access_token
        }
        if let facebook_token       = aDecoder.decodeObject(forKey: K_FacebookToken) as? String {
            self.facebook_token     =   facebook_token
        }
        if let gender               = aDecoder.decodeObject(forKey: K_PhoneNumbe) as? Int {
            self.gender             =   gender
        }
        if let idUser               = aDecoder.decodeObject(forKey: K_Id) as? Int {
            self.idUser             =   idUser
        }
        if let point                = aDecoder.decodeObject(forKey: K_Point) as? Int {
            self.point             =   point
        }
    }
    func userToDict(user: User)->[String:AnyObject]{
        var dict : [String:AnyObject]   = [:]
        dict[K_NickName]        =   user.nickname as AnyObject
        dict[K_CreatedAt]       =   user.createdAt as AnyObject
        dict[K_UserName]        =   user.user_name as AnyObject
        dict[K_FacebookID]      =   user.facebook_id as AnyObject
        dict[K_Email]           =   user.email as AnyObject
        dict[K_Avatar]          =   user.avatar as AnyObject
        dict[K_Cover]           =   user.cover as AnyObject
        dict[K_Birthday]        =   user.birthday as AnyObject
        dict[K_Carrier]         =   user.carrier as AnyObject
        dict[K_City]            =   user.city as AnyObject
        dict[K_Country]         =   user.country as AnyObject
        dict[K_CountryCode]     =   user.country_code as AnyObject
        dict[K_BundelID]        =  user.bundle_id as AnyObject
        dict[K_DeviceType]      =   user.device_type as AnyObject
        dict[K_DeviceID]        =   user.device_id as AnyObject
        dict[K_DeviceToken]     =   user.device_token as AnyObject
        dict[K_DeviceName]      =   user.device_name as AnyObject
        dict[K_WifiName]        =   user.wifi_name as AnyObject
        dict[K_IPs]             =   user.ips as AnyObject
        dict[K_Latitude]        =   user.latitude as AnyObject
        dict[K_Longitude]       =   user.longtitude as AnyObject
        dict[K_CallingCode]     =   user.calling_code as AnyObject
        dict[K_PhoneNumbe]      =   user.phone_number as AnyObject
        dict[K_AccessToken]     =   user.access_token  as AnyObject
        dict[K_FacebookToken]   =   user.facebook_token as AnyObject
        dict[K_Gender]          =   user.gender as AnyObject
        dict[K_Id]              =   user.idUser as AnyObject
        dict[K_Point]           =   user.point as AnyObject
        return dict
    }
    func saveUser(dict : [String:AnyObject]){
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        defaults.set(data, forKey: "currentUser")
        defaults.synchronize()
    }
    func getUser(dict : [String:AnyObject]) -> User{
        let defaults = UserDefaults.standard
        let data = defaults.value(forKey: "currentUser")
        let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! User
        return user
    }
    func encode(with aCoder: NSCoder) {
        if let nickname     = self.nickname {
            aCoder.encode(nickname, forKey: K_NickName)
        }
        if let createdAt     = self.createdAt {
            aCoder.encode(createdAt, forKey: K_CreatedAt)
        }
        if let user_name    = self.user_name {
            aCoder.encode(user_name, forKey: K_UserName)
        }
        if let facebook_id  = self.facebook_id {
            aCoder.encode(facebook_id, forKey: K_FacebookID)
        }
        if let email        = self.email {
            aCoder.encode(email, forKey: K_Email)
        }
        if let avatar       = self.avatar {
            aCoder.encode(avatar, forKey: K_Avatar)
        }
        if let cover        = self.cover {
            aCoder.encode(cover, forKey: K_Cover)
        }
        if let birthday     = self.birthday {
            aCoder.encode(birthday, forKey: K_Birthday)
        }
        if let carrier      = self.carrier {
            aCoder.encode(carrier, forKey: K_Carrier)
        }
        if let city         = self.city {
            aCoder.encode(city, forKey: K_City)
        }
        if let country      = self.country {
            aCoder.encode(country, forKey: K_Country)
        }
        if let country_code = self.country_code {
            aCoder.encode(country_code, forKey: K_CountryCode)
        }
        if let bundle_id    = self.bundle_id {
            aCoder.encode(bundle_id, forKey: K_BundelID)
        }
        if let device_type  = self.device_type {
            aCoder.encode(device_type, forKey: K_DeviceType)
        }
        if let device_id    = self.device_id {
            aCoder.encode(device_id, forKey: K_DeviceID)
        }
        if let device_name  = self.device_name {
            aCoder.encode(device_name, forKey: K_DeviceName)
        }
        if let device_token = self.device_token {
            aCoder.encode(device_token, forKey: K_DeviceToken)
        }
        if let wifi_name    = self.wifi_name {
            aCoder.encode(wifi_name, forKey: K_WifiName)
        }
        if let ips          = self.ips {
            aCoder.encode(ips, forKey: K_IPs)
        }
        if let latitude     = self.latitude {
            aCoder.encode(latitude, forKey: K_Latitude)
        }
        if let longtitude   = self.longtitude {
            aCoder.encode(longtitude, forKey: K_Longitude)
        }
        if let calling_code = self.calling_code {
            aCoder.encode(calling_code, forKey: K_CallingCode)
        }
        if let phone_number = self.phone_number {
            aCoder.encode(phone_number, forKey: K_PhoneNumbe)
        }
        if let access_token = self.access_token {
            aCoder.encode(access_token, forKey: K_AccessToken)
        }
        if let facebook_token = self.facebook_token {
            aCoder.encode(facebook_token, forKey: K_FacebookToken)
        }
        if let gender       = self.gender {
            aCoder.encode(gender, forKey: K_Gender)
        }
        if let idUser       = self.idUser {
            aCoder.encode(idUser, forKey: K_Id)
        }
        if let point       = self.point {
            aCoder.encode(point, forKey: K_Point)
        }
    }
    
}
