//
//  Onboard2ViewController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class Onboard2ViewController: UIViewController {

    @IBOutlet weak var QuestionLabel: UILabel!
   
    @IBOutlet weak var maleCircle: UIButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleCircle: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var WhyLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupQuestionLabel()
        
        setupWhyAsking()
        setupProgressLabel()
        setupNextButton()
       
    }
    
    @IBAction func maleButtonIsTapped(_ sender: UIButton) {
        
            }
    
    
    @IBAction func femaleButtonIsTapped(_ sender: UIButton) {
       
        
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    func updateMaleButton(isSelected: Bool) {
        let imageName = isSelected ? "circle" : "circle.fill"
        maleCircle.setImage(UIImage(named: imageName), for: .normal)
        femaleCircle.isEnabled = false
        
    }
    
  
    
    
    func setGradientBackground() {
          
          let  gradientLayer = CAGradientLayer()
          gradientLayer.frame = self.view.bounds
          gradientLayer.colors = [UIColor(named: "HomeControllerTopBG")?.cgColor ?? UIColor.blue.cgColor, UIColor(named: "HomeControllerBottBG")?.cgColor ?? UIColor.cyan]
          self.view.layer.insertSublayer(gradientLayer, at: 0)
          
          
      }
    
    func setupQuestionLabel() {
        QuestionLabel.textColor = .white
        QuestionLabel.text = "Would you prefer male or female clothing recommendations?"
    }
    
    func setupGenderSelection() {
        
        
    }
    
    
   func  setupWhyAsking() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Why are we asking?", attributes: underlineAttribute)
       WhyLabel.attributedText = underlineAttributedString
    }
    
    func setupProgressLabel() {
        progressLabel.textColor = .white
        progressLabel.text = "2 of 4"
    }
    
    func setupNextButton() {
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        
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
