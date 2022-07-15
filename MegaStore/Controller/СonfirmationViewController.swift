//
//  СonfirmationViewController.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 06.07.2022.
//

import UIKit

class СonfirmationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var confirmationTF: UITextField! {
        didSet {
            let bottomLine = CALayer()
            let marginsTF:CGFloat = 54
            bottomLine.frame = CGRect(x: 0.0, y: confirmationTF.frame.height - 12, width: UIScreen.main.bounds.width - marginsTF, height: 1.0)
            bottomLine.backgroundColor = UIColor.gray.cgColor
            confirmationTF.borderStyle = .none
            confirmationTF.layer.addSublayer(bottomLine)
        }
    }
    
    @IBOutlet weak var phoneLabel: UILabel! {
        didSet {
            let message = "Введите код из СМС, отправленного на номер "
            let targetString = message + phoneNumber!
            let range = NSMakeRange(0, message.count)
            
            phoneLabel.attributedText = attributedStringNonBoldRange(from: targetString, nonBoldRange: range)
        }
    }
    
    @IBOutlet weak var sendAgain: UIButton!
    
    var phoneNumber: String!
    private var answer: Answer?
    private var answer2: Answer2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NetworkManager.fetchDataAfterCodeRequest(jsonUrl: "https://utcoin.one/loyality/login_step1?phone=", phoneNumber: phoneNumber) { [weak self] answer in
            if answer.successful == true {
                self?.showAlert(title: "", message: answer.explainMessage)
                self?.answer = answer
            } else {
                self?.showAlert(title: answer.errorMessageCode, message: answer.errorMessage)
            }
        }
    }
    
    private func attributedStringNonBoldRange(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    private func showAlert(title: String, message: String) {
        let alertError = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertError.addAction(cancel)
        present(alertError, animated: true, completion: nil)
    }
    
    @IBAction func sendAgain(_ sender: Any) {
        NetworkManager.fetchDataAfterCodeRequest(jsonUrl: "https://utcoin.one/loyality/login_step1?phone=", phoneNumber: phoneNumber) { [weak self] answer in
            
            self?.answer = answer

            if answer.successful == true {
                self?.showAlert(title: "", message: answer.explainMessage)
            } else {
                self?.showAlert(title: answer.errorMessageCode, message: answer.errorMessage)
            }
        }
    }
    
    
    @IBAction func tapToHideKeyboard(_ sender: Any) {
        confirmationTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if confirmationTF.text?.isEmpty ?? true {
            let message = "Поле пустое! Введите данные для поиска"
            showAlert(title: "Ошибка!", message: message)
        } else {
            performSegue(withIdentifier: "toSearchScreen", sender: nil)
        }
        
        return true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchScreen" {
            guard let searchVC = segue.destination as? SearchScreenViewController else { return }
            searchVC.phoneNumber = phoneNumber
            searchVC.password = confirmationTF.text!
            confirmationTF.text = nil
        }
    }
}

