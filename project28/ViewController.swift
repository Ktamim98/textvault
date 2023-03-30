//
//  ViewController.swift
//  project28
//
//  Created by Tamim Khan on 30/3/23.
//
import LocalAuthentication
import UIKit



class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "nothing to see here"
        
        savePassword("pass")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(lockApp))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "identiy yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success{
                        self?.unlockSecretMessage()
                    }else{
//                        let ac = UIAlertController(title: "Authentication Faild", message: "you are unable to verified.please try again later", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "ok", style: .default))
                        self?.promptForPassword()
                    }
                }
                
            }
        }else{
//            let ac = UIAlertController(title: "Biometry unavailable", message: "you don't have biometry in your device", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "ok", style: .default))
//            present(ac, animated: true)
            promptForPassword()
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage(){
        secret.isHidden = false
        title = "secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
    }
    
    @objc func saveSecretMessage(){
       
        guard secret.isHidden == false else {return}
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "nothing to see here"
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    @objc func lockApp() {
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "nothing to see here"
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    func promptForPassword() {
        let ac = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let password = ac?.textFields?[0].text else { return }
            if self?.checkPassword(password) == true {
                self?.unlockSecretMessage()
            } else {
                let ac = UIAlertController(title: "Authentication Failed", message: "Incorrect password.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    func checkPassword(_ password: String) -> Bool {
       
        let savedPassword = KeychainWrapper.standard.string(forKey: "AppPassword")
        return password == savedPassword
    }

    func savePassword(_ password: String) {
        KeychainWrapper.standard.set(password, forKey: "AppPassword")
       
    }
    
}

