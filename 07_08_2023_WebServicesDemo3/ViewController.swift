//
//  ViewController.swift
//  07_08_2023_WebServicesDemo3
//
//  Created by Vishal Jagtap on 18/10/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var productTableView: UITableView!
    private let productTableViewCellReuseIdentifier = "ProductTableViewCell"
    var products : [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        registerXIBWithTableView()
        jsonParsing()
    }
    
    func initializeTableView(){
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
    func registerXIBWithTableView(){
        let uiNib = UINib(nibName: productTableViewCellReuseIdentifier, bundle: nil)
        productTableView.register(uiNib, forCellReuseIdentifier: productTableViewCellReuseIdentifier)
    }
    
    func jsonParsing(){
        let url = URL(string: "https://fakestoreapi.com/products")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
            let jsonObjects = try! JSONSerialization.jsonObject(with: data!) as! [[String : Any]]
            
            for eachProductObject in jsonObjects{
                let eachProduct = eachProductObject
                let eachProductId = eachProduct["id"] as! Int
                let eachProductTitle = eachProduct["title"] as! String
                let eachProductPrice = eachProduct["price"] as! Double
                
                let eachProductRating = eachProduct["rating"] as! [String : Any]
                let eachProductRate = eachProductRating["rate"] as! Double
                let eachProductCount = eachProductRating["count"] as! Int
                
                let newRating = Rating(
                    rate: eachProductRate,
                    count: eachProductCount)
                
                let newProduct = Product(
                    id: eachProductId,
                    title: eachProductTitle,
                    price: eachProductPrice,
                    rating: newRating)
                
                self.products.append(newProduct)
            }

            DispatchQueue.main.async {
                self.productTableView.reloadData()
            }
        }
        dataTask.resume()
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productTableViewCell = self.productTableView.dequeueReusableCell(withIdentifier: productTableViewCellReuseIdentifier, for: indexPath) as! ProductTableViewCell
        productTableViewCell.productIdLabel.text = String(products[indexPath.row].id)
        productTableViewCell.productRateLabel.text = String(products[indexPath.row].rating.rate)
        productTableViewCell.productCountLabel.text = String(products[indexPath.row].rating.count)
        
        return productTableViewCell
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0
    }
}
