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
    var location :Location?
    //MARK:- OUTLETS
    @IBOutlet weak var gear: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var dateLabel: UIStackView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UIStackView!
    @IBOutlet weak var feelsLikeLAbel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var middleContainer: UIView!
    
    
   

    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopContainer()
        setupMiddleContainer()
       
        
        
    }
    
    func setupTopContainer() {
        setGradientBackground()
    }
    
    func setGradientBackground() {
        
        let  gradientLayer = CAGradientLayer()
        gradientLayer.frame = topContainer.bounds
        gradientLayer.colors = [UIColor(named: "HomeControllerTopBG")?.cgColor ?? UIColor.blue.cgColor, UIColor(named: "HomeControllerBottBG")?.cgColor ?? UIColor.cyan]
       topContainer.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
    func setupMiddleContainer() {
        middleContainer.backgroundColor = UIColor(named: "HomeControllerBottBG")
        middleContainer.layer.cornerRadius = 20
        middleContainer.clipsToBounds = true
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




