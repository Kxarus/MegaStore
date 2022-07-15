//
//  SearchScreenViewController.swift
//  MegaStore
//
//  Created by Roman Kiruxin on 07.07.2022.
//

import UIKit

class SearchScreenViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var companiesCollectionView: UICollectionView!
    @IBOutlet weak var productsTableView: UITableView!
    
    var phoneNumber: String!
    var password: String!
    var loginIsCompleted: Bool = false
    private var answer2: Answer2?
    var search: Search?
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchFrame : CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
//        if !loginIsCompleted {
//            NetworkManager.fetchDataAfterEnteringTheCode(jsonUrl: "https://utcoin.one/loyality/login_step2?phone=", phoneNumber: phoneNumber, password: password) { [weak self] answer in
//                
//                if answer.successful == false {
//                    self?.showAlert(title: answer.errorMessageCode, message: answer.errorMessage)
//                } else {
//                    self?.answer2 = answer
//                    self?.loginIsCompleted = true
//                }
//            }
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        var navbarFrame = self.navigationController!.navigationBar.frame
        navbarFrame.size = CGSize(width: navbarFrame.width, height: navbarFrame.height + searchFrame!.height)
        self.navigationController?.navigationBar.frame = navbarFrame
        
        if !loginIsCompleted {
            NetworkManager.fetchDataAfterEnteringTheCode(jsonUrl: "https://utcoin.one/loyality/login_step2?phone=", phoneNumber: phoneNumber, password: password) { [weak self] answer in
                
                if answer.successful == false {
                    self?.showAlert(title: answer.errorMessageCode, message: answer.errorMessage)
                } else {
                    self?.answer2 = answer
                    self?.loginIsCompleted = true
                }
            }
        }
    }
    
    @IBAction func backToConfirmation(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertError = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
        alertError.addAction(cancel)
        present(alertError, animated: true, completion: nil)
    }
    
    func initSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchFrame = CGRectMake(0,(self.navigationController?.navigationBar.frame.height)!, (self.navigationController?.navigationBar.frame.width)!,searchController.searchBar.frame.height)
        searchController.searchBar.frame = searchFrame!
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
    }
    
    private func search(_ searchText: String) {
        
        let search = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        NetworkManager.fetchDataAfterUserRequest(searchString: search) { [weak self] answer in
            if answer.successful == false {
                self?.showAlert(title: answer.errorMessageCode, message: answer.errorMessage)
            } else {
                self?.search = answer
                self?.companiesCollectionView.reloadData()
                self?.productsTableView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailCampaign" {
            guard let companyDetailVC = segue.destination as? CompanyDetailsViewController else { return }
            guard let item = sender as? CampaignCell else { return }
            
            companyDetailVC.company = item.foundCompanies
            if item.storeLogo.image == nil {
                companyDetailVC.companyImage = UIImage(named: "НетКартинки")
            } else {
                companyDetailVC.companyImage = item.storeLogo.image
            }
        } else if segue.identifier == "toDetailProduct" {
            guard let productDetailVC = segue.destination as? ProductDetailViewController else { return }
            guard let cell = sender as? ProductCell else { return }

            productDetailVC.product = cell.foundProduct
            if cell.storeLogo != nil {
                productDetailVC.storeLogo = cell.storeLogo.image
            }
        }
    }
}

extension SearchScreenViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search("")
    }
}

extension SearchScreenViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let products = search?.products else { return 0 }
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductCell
        
        cell.foundProduct = search?.products[indexPath.row]
        cell.configure()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let companies = search?.campaigns else { return 0 }
        return companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "campaignCell", for: indexPath) as! CampaignCell
        
        item.foundCompanies = search?.campaigns[indexPath.row]
        item.configure()
        
        return item
    }
}

extension SearchScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 20 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
