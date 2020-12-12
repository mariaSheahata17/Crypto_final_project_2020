//
//  LoginViewController.swift
//  Twitter
//
//  Created by Maria Shehata on 9/30/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import RNCryptor

let encryptionKEY = "$3N2@C7@pXp"
let loginUsername = "3000100"
let loginPassword = "sF52bx24v~h^s-Y+3000100"

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openPage()

        // Do any additional setup after loading the view.
    }
    
    
    // Encrypt function
    func encrypt(plainText : String, password: String) -> String {
        
        let data: Data = plainText.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: encryptionKEY)
        let encryptedString : String = encryptedData.base64EncodedString() // getting base64encoded string of encrypted data.
        return encryptedString
    }
    // Decrypt Function
    func decrypt(encryptedText : String, password: String) -> String {
        do  {
            let data: Data = Data(base64Encoded: encryptedText)! // Just get data from encrypted base64Encoded string.
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
            return decryptedString ?? ""
        }
        catch {
            return "FAILED"
        }
    }
    
    func openPage() {
        let encryptedUsernameText =  self.encrypt(plainText: loginUsername, password: encryptionKEY)
        let encryptedPasswordText =  self.encrypt(plainText: loginPassword, password: encryptionKEY)
        let decryptedText1 = self.decrypt(encryptedText: encryptedUsernameText, password: encryptionKEY)
        let decryptedText2 = self.decrypt(encryptedText: encryptedPasswordText, password: encryptionKEY)
        print("encryptedUsernameText",encryptedUsernameText)
        print("encryptedPasswordText",encryptedPasswordText)
        print("decryptedText1",decryptedText1)
        print("decryptedText2", decryptedText2)
    }
    
 override func viewDidAppear(_ animated: Bool) {
    if UserDefaults.standard.bool(forKey: "userLoggedin") == true {
        self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
 }
 

    @IBAction func onLoginButton(_ sender: Any) {
        let myURL = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myURL, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedin")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: {(Error) in
            print("could not login")
        })
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
