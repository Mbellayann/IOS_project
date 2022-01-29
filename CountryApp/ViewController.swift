//
//  ViewController.swift
//  CountryApp
//
//  Created by Ingrid bikoli on 20/01/2022.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imgView.image = image
                self.imgView.layer.cornerRadius = 25
            }
        }
    }
}



class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate{
    
    
    
    
    @IBOutlet weak var countryTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var fetchCountry = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countryTableView.dataSource = self
        countryTableView.delegate=self
        parseData()
        searchMth()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func searchMth(){
        let sB = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        sB.delegate = self
        sB.showsScopeBar = true
        sB.tintColor = UIColor.lightGray
        sB.scopeButtonTitles = ["Country", "Code"]
        self.countryTableView.tableHeaderView = sB
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            parseData()
        }else{
            if searchBar.selectedScopeButtonIndex == 0 {
                fetchCountry = fetchCountry.filter({(country) -> Bool in
                    return  country.country!.lowercased().contains(searchText.lowercased())
                })
            }else{
                fetchCountry = fetchCountry.filter({(country) -> Bool in
                    return country.alpha2Code!.contains(searchText.uppercased())
                })
            }
        }
        self.countryTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fetchCountry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "cell")as! MyTableViewCell
        cell.countryLabel?.text = fetchCountry[indexPath.row].country
        
        cell.countryCode?.text = fetchCountry[indexPath.row].alpha2Code
        
        let urlString  = fetchCountry[indexPath.row].flag!["png"]!
        cell.setImage(from: urlString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ici")
        if let vc = (storyboard!.instantiateViewController(withIdentifier: "SecondViewController")) as?
            SecondViewController{
            vc.country = (fetchCountry[indexPath.row])
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
                        let capital : String?
                        if(eachCountry["capital"] == nil)
                        {
                            capital = "no capital"
                        }else
                        {
                            capital = eachCountry["capital"] as? String
                        }
                        let flag = eachCountry["flags"]
                        let code = eachCountry["alpha2Code"] as! String
                        
                        let area = "\(String(describing: eachCountry["area"]))"
                        let population = "\(String(describing: eachCountry["population"]))"
                        let region = "\(String(describing: eachCountry["region"]))"
                        let timezone = "\(String(describing: eachCountry["timezones"]))"
                        let position = "\(String(describing: eachCountry["position"]))"
                        
                        self.fetchCountry.append(Country(country: country, capital: capital, flags: flag as? [String : String], alpha2Code: code,
                                                       area: area,
                                                        Population: population,
                                                        Region: region,
                                                        Timezone: timezone,
                                                        Position: position))
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
    var alpha2Code : String?
    
    
    var officialName : String?
    var area : String?
    var population : String?
    var currency : String?
    var region : String?
    var timezone : String?
    var languages : String?
    var position : String?
    
    init(country : String? = nil , capital : String? = nil , flags : [String:String]? = nil, alpha2Code : String? = nil,
         officialName : String? = nil, area : String? = nil, Population : String? = nil,  Region : String? = nil, Timezone : String? = nil, Position : String? = nil)
    {
        self.country = country
        self.capital = capital
        self.flag = flags
        self.alpha2Code = alpha2Code
        self.area = area
        self.population = Population
        self.region = Region
        self.timezone = Timezone
        self.position = Position
    }
    
}

