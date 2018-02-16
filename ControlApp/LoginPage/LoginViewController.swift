//
//  LoginViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/18.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
////////////////////////////////////////////////////////////
//  Update History:
//  Jan.18th.2018 Help button alert action for contact, term of use(not designed yet) and cancel.
//  ------------- Sign in button jump to main page, keychain not implemented yet.
//  Jan.23th.2018 Access Ewon login api and implement loading animation.
//  Jan.24th.2018 Implement keychain store and biological id verification
//  All api access functions are transferred to EwonApiCase class now.
////////////////////////////////////////////////////////////

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController{
    @IBOutlet weak var Act_Login_Loading: UIActivityIndicatorView!
    @IBOutlet weak var TF_account: UITextField!
    @IBOutlet weak var TF_username: UITextField!
    @IBOutlet weak var TF_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myViewContentInit()
        // Do any additional setup after loading the view, typically from a nib.
        self.TF_password.isSecureTextEntry = true
        Act_Login_Loading.isHidden = true
        verifyBioPassword()
        
    }
    private func myViewContentInit(){
        setTextFieldStyle(field: TF_account, imageName: "tag")
        setTextFieldStyle(field: TF_username, imageName: "tag")
        setTextFieldStyle(field: TF_password, imageName: "lock")
    }
    private func setTextFieldStyle(field:UITextField, imageName: String) {
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 5
        field.layer.borderColor = UIColor.white.cgColor
        /*if UIImage(named: imageName) != nil {
            field.leftView = UIImageView(image: UIImage(named: imageName))
            field.leftView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            field.leftViewMode = .always
        }*/
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Action for tapping help button with three options
    @IBAction func HelpButton_TouchUpInside(_ sender: UIButton) {
        let popbottom = UIAlertController(title: "Help", message: "Contact us if need account & password", preferredStyle: .actionSheet)
        /// Option: Contact Alfa Laval, dial the number of niagara blowers
        popbottom.addAction(UIAlertAction(title: NSLocalizedString("Contact Alfa Laval", comment: "Default action"), style: .destructive, handler: { _ in
            guard let number = URL(string: "tel://7168752000") else { return }
            UIApplication.shared.open(number)
        }))
        /// Option: Term of use, currently visit the 'about us' web page in al niagara website
        popbottom.addAction(UIAlertAction(title: NSLocalizedString("Term of use", comment: "Default action"), style: .default, handler: { _ in
            guard let webAddress = URL(string: "http://www.niagarablower.com/About") else { return }
            UIApplication.shared.open(webAddress, options: [:], completionHandler: nil)
        }))
        /// Cancel
        popbottom.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            NSLog("The \"Cancel\" alert occured.")
        }))
        
        self.present(popbottom, animated: true, completion: nil)
    }
    
    /// Action for tapping sign in button
    @IBAction func SignInButton_TouchUpInside(_ sender: UIButton) {
        /// Verification here
        Act_Login_Loading.isHidden = false
        Act_Login_Loading.startAnimating()
        ewon.verifyKeychain(account: TF_account.text!, userName: TF_username.text!, password: TF_password.text!, completion: self.permitLogin(result:code:))
        ///
    }
    
    /// Hide the keyboard when tap the blank
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    private func permitLogin(result:String,code:Int) {
        Act_Login_Loading.stopAnimating()
        self.Act_Login_Loading.isHidden = true
        switch result {
        case "fail":
            let tempWarning : String = "Your acccount/username/password combination is invalid or too many concurrent connections.\nPlease try again later."
            denyLogin(warning: tempWarning)
            break
        case "error":
            let tempWarning : String = "Error code:\(code)\nPlease try later or contact the administrator."
            denyLogin(warning: tempWarning)
            break
        default:
            storeKeyChain(account: TF_account.text!, userName: TF_username.text!, password: TF_password.text!, session: result)
            /** Head to main page.
             The id verification should be done before this segue.
             */
            self.performSegue(withIdentifier: "LoginToStatus", sender: self)
            break
        }
    }
    
    private func denyLogin(warning:String) {
        let alert = UIAlertController(title: "Login Failed", message: warning, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func storeKeyChain(account:String, userName:String, password: String, session: String) {
        userParameter.t2maccount = account
        userParameter.t2musername = userName
        userParameter.t2mpassword = password
        userParameter.t2msession = String(session.utf8)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userParameter){
            UserDefaults.standard.set(encoded, forKey: "userParameter")
        }
    }
    
    private func verifyBioPassword(){
        let context = LAContext()
        var error: NSError?
        if let myData = UserDefaults.standard.value(forKey: "userParameter") as? Data{
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(UserParameters.self, from: myData){
                userParameter = objectsDecoded
                
                /// Touch iD / Face iD Verification
                if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
                    context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Verify your identity for auto-login", reply: { (success,error) in
                        if success {
                            /// Login Verification here
                            ewon.verifyKeychain(account: userParameter.t2maccount, userName: userParameter.t2musername, password: userParameter.t2mpassword, completion: self.permitLogin(result:code:))
                            ///
                        }
                        else {
                            return
                        }
                    })
                }
                else {
                    TF_account.text = userParameter.t2maccount
                    TF_username.text = userParameter.t2musername
                    /// Password is not recommended for auto-fill-out
                    //TF_password.text = userParameter.t2mpassword
                }
                ///
            }
        }
        else {
            print("No username/password record.")
        }
        
    }
}

