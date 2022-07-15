//
//  ProductDetailViewController.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 13.07.2022.
//

import UIKit

class ProductDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var price: UILabel!
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
    
    var product: Product?
    var productImages: [UIImage?] = []
    private var isUnfold: Bool = false
    
    var storeLogo: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        productInformationConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureProductImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageDisplayConfiguration()
    }
    
    func configureProductImages() {
        guard let product = product else { return }

        for imageUrl in product.imageUrls {
            DispatchQueue.global().async { [weak self] in
                guard let imageProductUrl = URL(string: imageUrl ?? "") else { return }
                guard let imageProductData = try? Data(contentsOf: imageProductUrl) else { return }
                DispatchQueue.global().async {
                    self?.productImages.append(UIImage(data: imageProductData))
                }
            }
        }

    }
    
    private func imageDisplayConfiguration() {
        pageControl.numberOfPages = productImages.count
        for index in 0..<productImages.count {
            let productImageView = UIImageView()
            productImageView.contentMode = .scaleAspectFit
            productImageView.image = productImages[index]
            let xPos = CGFloat(index) * self.view.bounds.width
            productImageView.frame = CGRect(x: xPos, y: 0, width: view.frame.size.width, height: imageScrollView.frame.size.height)
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(index + 1)
            imageScrollView.addSubview(productImageView)
        }
        
        imageScrollView.contentSize = CGSize(width: (imageScrollView.frame.size.width * CGFloat(productImages.count )), height: imageScrollView.frame.size.height)
        imageScrollView.delegate = self
    }
    
    private func productInformationConfiguration() {
        
        guard let product = product else { return }
        productName.text = product.name
        
        if storeLogo != nil {
            companyLogo.image = storeLogo
        } else {
            companyName.text = product.campaignName
        }
        price.text = product.price
        cashback.text = product.cashback
        paymentTime.text = product.paymentTime
        
        if product.actions.count > 0 {
            let message = product.actions[0]!.value + " " +  product.actions[0]!.text
            let range = NSMakeRange(0, product.actions[0]!.value.count)
            conditions.attributedText = attributedStringNonBoldRanges(from: message, nonBoldRanges: [range])
        } else {
            conditions.text = "условия отсутствуют"
            unfolding.isHidden = true
        }
    }
    

    @IBAction func unfoldСonditions(_ sender: Any) {
        guard let product = product else { return }
        
        if isUnfold == false {
            
            var message = ""
            var rangeArray: [NSRange?] = []
            var startRange = 0
            
            if product.actions.count > 1 {
                for action in product.actions {
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
            let message = product.actions[0]!.value + " " +  product.actions[0]!.text
            let range = NSMakeRange(0, (product.actions[0]!.value).count)
            conditions.attributedText = attributedStringNonBoldRanges(from: message, nonBoldRanges: [range])
            
            unfolding.setTitle("Развернуть", for: .normal)
            unfolding.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            isUnfold = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = imageScrollView.contentOffset.x/imageScrollView.frame.width
        pageControl.currentPage = Int(page)
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
