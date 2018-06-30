//
//  AddViewController.swift
//  CustomAddressBook


import Foundation
import UIKit

class AddViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var lastNameField : UITextField!
    @IBOutlet weak var phoneField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var addressField : UITextField!
    
    var person : Person?
    
    @IBAction func addButtonPressed(_ sender : UIButton) {
        //NSLog("Button pressed")
        
        if person == nil {
            if let p = Person(firstName:nameField.text!) {
                person = p
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.contactsArray.append(person!)
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Error creating contact", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        }
        
        do {
            try person!.setFirstName(nameField.text!)
            try person!.setLastName(lastNameField.text!)
            try person!.setPhone(phoneField.text!)
            try person!.setEmail(emailField.text!)
            try person!.setAddress(addressField.text!)
        } catch let error as PersonValidationError {
            var errorMsg = ""
            
            switch(error) {
            case .invalidFirstName:
                errorMsg = "Invalid first name"
            case .invalidAddress:
                errorMsg = "Invalid address"
            case .invalidEmail:
                errorMsg = "Invalid email address"
            case .invalidPhone:
                errorMsg = "Invalid phone number"
            }
            
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } catch {
            
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.storeContactsArray()
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        if let person = person {
            nameField.text = person.firstName
            lastNameField.text = person.lastName
            phoneField.text = person.phone
            emailField.text = person.email
            addressField.text = person.address
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
}
