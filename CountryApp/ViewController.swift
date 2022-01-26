//
//  ViewController.swift
//  CountryApp
//
//  Created by Ingrid bikoli on 20/01/2022.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imgView.image = image
            }
        }
    }
}



class ViewController: UIViewController, UITableViewDataSource {
    
    
    
    @IBOutlet weak var countryTableView: UITableView!
    
    
    var fetchCountry = [Country]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countryTableView.dataSource = self
        parseData()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fetchCountry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "cell")as! MyTableViewCell
        cell.textLabel?.text = fetchCountry[indexPath.row].country
        cell.detailTextLabel?.text = fetchCountry[indexPath.row].capital
        let urlString  = fetchCountry[indexPath.row].flag!["png"]!
        cell.setImage(from: urlString)
        return cell
    }
    
    func parseData(){
        fetchCountry = []
        let url = "https://restcountries.com/v2/all"
        var request = URLRequest(url:URL(string:url)!)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request){(data, response,error) in
            if(error != nil)
            {
                print("error")
            }else
            {
                do{
                    let fetchData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    for eachfetchCountry in fetchData
                    {
                        let eachCountry = eachfetchCountry as! [String : Any]
                        let country = eachCountry["name"] as! String
                        //print(country)
                        let capital : String
                        if(eachCountry["capital"] == nil)
                        {
                            capital = "no capital"
                        }else
                        {
                            capital = eachCountry["capital"] as! String
                        }
                        let flag = eachCountry["flags"]
                        
                        self.fetchCountry.append(Country(country: country, capital: capital, flags: flag as! [String : String]))
                    }
                    self.countryTableView.reloadData()
                }
                catch{
                    print("error2")
                }
            }
        }
        task.resume()
    }
}

class Country {
    var country : String?
    var capital : String?
    var flag : [String:String]?
    
    init(country : String? = nil , capital : String? = nil , flags : [String:String]? = nil)
    {
        self.country = country
        self.capital = capital
        self.flag = flags
    }
    
}

