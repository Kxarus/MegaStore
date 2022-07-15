//
//  CompanyDetailsViewController.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 11.07.2022.
//

import UIKit

class CompanyDetailsViewController: UIViewController {

    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var cashback: UILabel! {
        didSet {
            cashback.layer.masksToBounds = true
            cashback.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var paymentTime: UILabel!
    @IBOutlet weak var conditions: UILabel!
    @IBOutlet weak var unfolding: UIButton! {
        didSet {
            unfolding.setTitle("Развернуть", for: .normal)
            unfolding.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
    }
    
    var company: Campaign?
    var companyImage: UIImage?
    private var isUnfold: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func unfoldСonditions(_ sender: Any) {
    
        guard let campaign = company else { return }
        
        if isUnfold == false {
            
            var message = ""
            var rangeArray: [NSRange?] = []
            var startRange = 0
            
            if campaign.actions.count > 1 {
                for action in campaign.actions {
                    message += (action?.value)! + " " +  (action?.text)! + "\n"
                    let range = NSMakeRange(startRange, (action?.value.count)!)
                    rangeArray.append(range)
                    startRange = message.count
                }
                
                conditions.attributedText = attributedStringNonBoldRanges(from: message, nonBoldRanges: rangeArray)
                
                unfolding.setTitle("Свернуть", for: .normal)
                unfolding.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                isUnfold = true
            } else {
                unfolding.setTitle("Свернуть", for: .normal)
                unfolding.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                isUnfold = true
            }
        } else {
            let message = campaign.actions[0]!.value + " " +  campaign.actions[0]!.text
            let range = NSMakeRange(0, (campaign.actions[0]!.value).count)
            conditions.attributedText = attributedStringNonBoldRanges(from: message, nonBoldRanges: [range])
            
            unfolding.setTitle("Развернуть", for: .normal)
            unfolding.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            isUnfold = false
        }
    }
    
    private func configure() {
        storeLogo.image = companyImage
        companyName.text = company?.name
        cashback.text = company?.cashback
        paymentTime.text = company?.paymentTime
        
        if (company?.actions.count)! > 0 {
            let message = (company?.actions[0]!.value)! + " " +  (company?.actions[0]!.text)!
            let range = NSMakeRange(0, (company?.actions[0]!.value)!.count)
            conditions.attributedText = attributedStringNonBoldRanges(from: message, nonBoldRanges: [range])
        } else {
            conditions.text = "условия отсутствуют"
            unfolding.isHidden = true
        }
    }
    
    private func attributedStringNonBoldRanges(from string: String, nonBoldRanges: [NSRange?]) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        
        for range in nonBoldRanges {
            if let range = range {
                attrStr.setAttributes(nonBoldAttribute, range: range)
            }
        }
        return attrStr
    }
}
