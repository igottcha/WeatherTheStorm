//
//  Onboard2ViewController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class Onboard2ViewController: UIViewController {
    
    var isSelected = UIImage(systemName: "circle.fill")
    var notSelected = UIImage(systemName: "circle")
    var toggleStateM = 1
    var toggleStateF = 1
    var isMale = true
    
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
        setupGenderLabels()
        setupCircles()
        
        
        setupWhyAsking()
        setupProgressLabel()
        setupNextButton()
        
    }
    
    @IBAction func maleButtonIsTapped(_ sender: UIButton) {
        if toggleStateM == 1 {
            toggleStateM = 2
            maleCircle.setImage(isSelected, for: .normal)
            femaleCircle.isEnabled = false
            maleCircle.isEnabled = true
            isMale = true
            UserController.shared.saveGender(gender: true)
            
        }
        else {
            toggleStateM = 1
            maleCircle.setImage(notSelected, for: .normal)
            femaleCircle.isEnabled = true
            isMale = false
            UserController.shared.saveGender(gender: false)
            
            
        }
        
    }
    
    func setupCircles() {
      
        maleCircle.setImage(UIImage(systemName: "circle"), for: .normal)
        femaleCircle.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func femaleButtonIsTapped(_ sender: UIButton) {
        
        if toggleStateF == 1 {
            toggleStateF = 2
            femaleCircle.setImage(isSelected, for: .normal)
            maleCircle.isEnabled = false
            femaleCircle.isEnabled = true
            isMale = false
            UserController.shared.saveGender(gender: false)
            
        }
        else {
            toggleStateM = 1
            femaleCircle.setImage(notSelected, for: .normal)
            maleCircle.isEnabled = true
            isMale = true
            UserController.shared.saveGender(gender: true)
            
            
        }
        
        
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
     performSegue(withIdentifier: "toCitySelectionVC", sender: self)
    }
    
 
    
    func setupGenderLabels(){
        maleLabel.text = "Male"
        femaleLabel.text = "Female"
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
        WhyLabel.textColor = .white
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
