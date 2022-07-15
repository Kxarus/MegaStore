//
//  ProductCell.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 11.07.2022.
//

import UIKit

class ProductCell: UITableViewCell {

    var foundProduct: Product?
    
    @IBOutlet weak var product: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cashback: UILabel! {
        didSet {
            cashback.layer.masksToBounds = true
            cashback.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var campaignName: UILabel!
    
    func configure() {
        
        productName.text = foundProduct?.name
        price.text = foundProduct?.price
        cashback.text = foundProduct?.cashback
        
        configureProductLogo()
        configureCompanyLogo()
    }
    
    func configureProductLogo() {
        DispatchQueue.global().async {
            guard let imageProductUrl = URL(string: self.foundProduct?.imageUrls[0] ?? "") else { return }
            guard let imageProductData = try? Data(contentsOf: imageProductUrl) else { return }

            DispatchQueue.main.async {
                self.product.image = UIImage(data: imageProductData)
            }
        }
    }
    
    func configureCompanyLogo() {
        DispatchQueue.global().async { [weak self] in
            
            if let campaignImageUrl = self?.foundProduct?.campaignImageURL {
                guard let imageCompanyUrl = URL(string: campaignImageUrl) else { return }
                guard let imageCompanyData = try? Data(contentsOf: imageCompanyUrl) else { return }
                DispatchQueue.main.async {
                    self?.storeLogo.image = UIImage(data: imageCompanyData)
                }
            } else {
                DispatchQueue.main.async {
                    self?.campaignName.text = self?.foundProduct?.campaignName
                }
            }
        }
    }
}
