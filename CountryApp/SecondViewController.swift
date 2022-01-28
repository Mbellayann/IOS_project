//
//  SecondViewController.swift
//  CountryApp
//
//  Created by Ingrid bikoli on 28/01/2022.
//

import UIKit

class MySecondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
}

class SecondViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var detailView: UITableView!
    
    @IBOutlet weak var img: UIImageView!
    
    var country = Country()
    
    
    let titles = ["Official Name","Capital","Area","Population","Currency","Region","Timezone","Languages","GPS Position"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.dataSource = self
        detailView.delegate = self
        // Do any additional setup after loading the view.
        //verified if all items coming from th efirst screen are nil 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titles.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell") as! MySecondTableViewCell
        cell.title.text = "yann"
        print("salut")
        return cell
        
    }

}
