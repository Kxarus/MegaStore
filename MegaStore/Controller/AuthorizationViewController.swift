//
//  AuthorizationViewController.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 06.07.2022.
//

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var phoneNumberTF: UITextField! {
        didSet {
            let bottomLine = CALayer()
            let marginsTF:CGFloat = 50
            bottomLine.frame = CGRect(x: 0.0, y: phoneNumberTF.frame.height - 12, width: UIScreen.main.bounds.width - marginsTF, height: 1.0)
            bottomLine.backgroundColor = UIColor.gray.cgColor
            phoneNumberTF.borderStyle = .none
            phoneNumberTF.layer.addSublayer(bottomLine)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enteringNumber(_ sender: Any) {
        if phoneNumberTF.text?.isEmpty ?? true {
            let message = "Поле пустое! Введите данные для поиска"
            showAlert(message: message)
        } else {
            performSegue(withIdentifier: "toConfirmation", sender: nil)
            phoneNumberTF.text = nil
        }
    }
    
    @IBAction func tapToHideKeyboard(_ sender: Any) {
        phoneNumberTF.resignFirstResponder()
    }
    
    private func showAlert(message: String) {
        let alertError = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertError.addAction(cancel)
        present(alertError, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmation" {
            guard let confirmationVC = segue.destination as? СonfirmationViewController else { return }
            confirmationVC.phoneNumber = phoneNumberTF.text!
        }
    }

}
