//
//  SecondViewController.swift
//  CountryApp
//
//  Created by Ingrid bikoli on 28/01/2022.
//

import UIKit

class MySecondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var country = Country()
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var detailView: UITableView!
    
    let titles = ["Official Name","Capital","Area","Population","Region","GPS Position"]
    var countryDetails : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.dataSource = self
        detailView.delegate = self
        // Do any additional setup after loading the view.
        countryDetails = [country.country!, country.capital!, (country.area ?? "") as! String, country.population!, (country.region ?? "") as! String,  "\(country.position!)"]
        self.setImage(from: country.flag!["png"]!)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titles.count
        }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("on es lz")
        let cell = detailView.dequeueReusableCell(withIdentifier: "cel")as! MySecondTableViewCell
        let title = self.titles[indexPath.row]
   
        
        
        cell.lbl2?.text = title
        cell.lbl?.text = countryDetails[indexPath.row]
        return cell
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.img.image = image
            }
        }
    }
        
    
    

}
