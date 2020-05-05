//
//  ForecastDetailViewController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/29/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController {
    //MARK: PROPERTIES
    
    var date: Date = Date()
    //MARK:- OUTLETS
    
   
    @IBOutlet weak var hourlyForecastTableView: UITableView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    @IBOutlet weak var wearLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGreetingLabel()
        setupDateLabel()
        setupTempLabel()
        setupFeelsLikelabel()
        hourlyForecastTableView.delegate = self
        hourlyForecastTableView.dataSource = self
       
    }
    
    func setupGreetingLabel(){
       greetingLabel.text = "Good Morning, \(UserController.shared.userName)! it's a (Phrase Will Go Here) day in (Location will go here)"
       }

       func setupDateLabel() {
           dateLabel.text = self.date.formatDate()
           
       }
       
       func setupTempLabel(){
           tempLabel.text = "72º"
       }
       
       func setupFeelsLikelabel(){
           
           feelsLikeLabel.text = "Feels like (feels like will go here)"
       }
       
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ForecastDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = hourlyForecastTableView.dequeueReusableCell(withIdentifier: "hourlyForecastTableViewCell", for: indexPath) as? HourlyForecastTableViewCell else {return UITableViewCell()}
        
        return cell
        
    }
    
    
    
}
