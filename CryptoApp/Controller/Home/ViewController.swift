//
//  ViewController.swift
//  bundleApp
//
//  Created by Anıl AVCI on 13.07.2022.
//

import UIKit
import SDWebImageSVGCoder


final class ViewController: UIViewController {
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSelectCoin: UIButton!
    public var coinListVM:CoinListViewModel!
    
    let searchController = UISearchController(searchResultsController: nil)
    let cell = "cell"
    let transparentView = UIView()
    let tableViewFilter = UITableView()
    var selectedButton = UIButton()
    var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tabledelegate()
        configureSearchController()
        //MARK: -  Get data
        coinListVM = CoinListViewModel(APIService: APICallService(service: APICaller()))
        guard let viewModel = coinListVM else {return}
        viewModel.getCrypto {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func registerCells() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cell)
        tableViewFilter.register(ClassCell.self, forCellReuseIdentifier: "CellFilter")
        btnSelectCoin.layer.cornerRadius = 15
        btnSelectCoin.layer.masksToBounds = true
        
    }
    private func tabledelegate() {
        tableViewFilter.delegate = self
        tableViewFilter.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    //MARK: - Filter Button Settings
    @IBAction func onClickSelectCoin(_ sender: UIButton) {
        dataSource = ["Price", "Market Cap", "24h Volume","Change","Listed at"]
        selectedButton = btnSelectCoin
        addTransparentView(frames: btnSelectCoin.frame)
    }
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        tableViewFilter.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableViewFilter)
        tableViewFilter.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableViewFilter.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableViewFilter.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableViewFilter.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

    // MARK: - Sort Menu Func.
    @objc func sortBy24hVol() {
        guard let viewModel = self.coinListVM else {return}
        viewModel.coinArray.sort{ (coinOne, coinTwo) -> Bool in
            return coinOne.the24HVolume ?? "" < coinTwo.the24HVolume ?? ""
        }
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
    }
    
    @objc func sortByPrice() {
        guard let viewModel = self.coinListVM else {return}
        viewModel.coinArray.sort{ (coinOne, coinTwo) -> Bool in
            return coinOne.price! < coinTwo.price!
        }
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
    }
    
    @objc func sortByChange() {
        guard let viewModel = self.coinListVM else {return}
        viewModel.coinArray.sort{ (coinOne, coinTwo) -> Bool in
            return coinOne.change! < coinTwo.change!
        }
        
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
    }
    
    @objc func sortByMarketCap() {
        guard let viewModel = self.coinListVM else {return}
        viewModel.coinArray.sort{ (coinOne, coinTwo) -> Bool in
            return coinOne.marketCap! < coinTwo.marketCap!
        }
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
    }
    @objc func sortByListedAt() {
        guard let viewModel = self.coinListVM else {return}
        viewModel.coinArray.sort{ (coinOne, coinTwo) -> Bool in
            return coinOne.listedAt! < coinTwo.listedAt!
        }
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
    }
    /// Searchbar Programatic Add Properties
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchTextField.textColor = .lightGray
        searchController.searchBar.searchTextField.leftView?.tintColor = .darkGray
        searchController.searchBar.searchTextField.layer.borderWidth = 0.7
        searchController.searchBar.searchTextField.layer.borderColor = CGColor.init(gray: 0.7, alpha: 0.3)
        searchController.searchBar.searchTextField.layer.cornerRadius = 6
    }
}
//MARK: - TableView Delegate and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return coinListVM.coinArray.count
        } else {
            return dataSource.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            cell.setup(coins: coinListVM.coinArray[indexPath.row])
            return cell
        } else  {
            let cellFilter = tableViewFilter.dequeueReusableCell(withIdentifier: "CellFilter", for: indexPath)
            cellFilter.textLabel?.text = dataSource[indexPath.row]
            return cellFilter
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableViewFilter {
            if indexPath.row == 0 {
                selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
                removeTransparentView()
                sortByPrice()
            } else if indexPath.row == 1 {
                selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
                removeTransparentView()
                sortByMarketCap()
            } else if indexPath.row == 2 {
                selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
                removeTransparentView()
                sortBy24hVol()
            } else if indexPath.row == 3 {
                selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
                removeTransparentView()
                sortByChange()
            } else if indexPath.row == 4 {
                selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
                removeTransparentView()
                sortByListedAt()
                
            } else if tableView == tableView {
                selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
                removeTransparentView()
                sortByPrice()
            }
        } else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
            let selectedCoin = coinListVM.coinArray[indexPath.row]
            vc?.selectedCrypto = selectedCoin
           self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
// MARK: Search Bar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        coinListVM.filtered = self.coinListVM.mainArray.filter({ (coin) -> Bool in
            return coin.name!.lowercased().contains(searchText.lowercased())
        })
        if searchText.isEmpty {
            coinListVM.coinArray = coinListVM.mainArray
        } else {
            coinListVM.coinArray = coinListVM.filtered
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        coinListVM.coinArray = coinListVM.mainArray
        tableView.reloadData()
    }
}
