//
//  CampaignCell.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 11.07.2022.
//

import UIKit

class CampaignCell: UICollectionViewCell {
    
    var foundCompanies: Campaign?
    
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var cashback: UILabel! {
        didSet {
            cashback.layer.masksToBounds = true
            cashback.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var companyName: UILabel!
    
    func configure() {
        cashback.text = foundCompanies?.cashback
        
        let imageURL = foundCompanies?.imageURL
        if imageURL != nil {
            DispatchQueue.global().async {
                guard let imageUrl = URL(string: imageURL!) else { return }
                guard let imageData = try? Data(contentsOf: imageUrl) else { return }

                DispatchQueue.main.async {
                    self.storeLogo.image = UIImage(data: imageData)
                }
            }
        } else {
            companyName.text = foundCompanies?.name
        }
    }
}
