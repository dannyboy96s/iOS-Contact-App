//
//  Person.swift
//  CustomAddressBook


import Foundation

enum PersonValidationError : Error {
    case invalidFirstName
    case invalidAddress
    case invalidPhone
    case invalidEmail
}

class Person : NSObject, NSCoding {
    fileprivate(set) var firstName : String?
    fileprivate(set) var lastName : String?
    fileprivate(set) var address : String?
    fileprivate(set) var phone : String?
    fileprivate(set) var email : String?
    
    init?(firstName fn : String) {
        //firstName = fn
        super.init()
        do {
            try setFirstName(fn)
        } catch {
            return nil
        }
    }
    
    required init?(coder aDecoder : NSCoder) {
        if let s = aDecoder.decodeObject(forKey: "firstName") as? String {
            firstName = s
        }
        if let s = aDecoder.decodeObject(forKey: "lastName") as? String {
            lastName = s
        }
        if let s = aDecoder.decodeObject(forKey: "phone") as? String {
            phone = s
        }
        if let s = aDecoder.decodeObject(forKey: "email") as? String {
            email = s
        }
        if let s = aDecoder.decodeObject(forKey: "address") as? String {
            address = s
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(address, forKey: "address")
    }
    
    func setFirstName(_ fn : String) throws {
        if (fn.characters.count < 1) {
            throw PersonValidationError.invalidFirstName
        }
        firstName = fn
    }
    
    func setLastName(_ ln : String) throws {
        lastName = ln
    }
    
    func setAddress(_ ad : String) throws {
        if (ad.characters.count != 0) {
            //45 N 3rd St
            if (ad.characters.count < 3) {
                throw PersonValidationError.invalidAddress
            }
            //make sure there's a space
            if let _ = ad.characters.index(of: " ") {
                
            } else {
                throw PersonValidationError.invalidAddress
            }
        }
        
        address = ad
    }
    
    func setPhone(_ pn : String) throws {
        if (pn.characters.count != 0) {
            let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
            
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result = phoneTest.evaluate(with: pn)
            
            if (!result) {
                throw PersonValidationError.invalidPhone
            }
        }
        
        phone = pn
    }
    
    func setEmail(_ em : String) throws {
        if (em.characters.count != 0) {
            let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@",emailRegEx)
            
            let result = emailTest.evaluate(with: em)
            if (!result) {
                throw PersonValidationError.invalidEmail
            }
        }
        
        email = em
    }
    
    
}
