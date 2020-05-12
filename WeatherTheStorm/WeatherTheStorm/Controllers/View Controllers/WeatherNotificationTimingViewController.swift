//
//  WeatherNotificationTimingViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class WeatherNotificationTimingViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!
    @IBOutlet weak var daysOfTheWeekTableView: UITableView!
    @IBOutlet weak var setNotificationButton: UIButton!
    
    //MARK: - Properties
    
    var weatherNotification: WeatherNotification?
    var location: Location?
    let datePicker = UIDatePicker()
    
    //MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysOfTheWeekTableView.isHidden = true
        guard let city = location?.destination?.locality, let address = location?.destination?.thoroughfare, let state = location?.destination?.administrativeArea, let country = location?.destination?.country else { return }
        addressLabel.text = "\(address), \(city), \(state), \(country)"
        createDatePicker()
        setNotificationButton.layer.cornerRadius = 7
        setNotificationButton.isHidden = true
    }

    //MARK: - Actions
    
    @IBAction func repeatTextFieldDidBeginEditing(_ sender: UITextField) {
        daysOfTheWeekTableView.isHidden = false
    }
    @IBAction func setNotificationButtonTapped(_ sender: UIButton) {
    }
    

    //MARK: - Methods
    
    func sortWeekdayArray() -> [String] {
        guard let week = DateFormatter().weekdaySymbols, let notificationFrequency = weatherNotification?.frequency else { return [] }
        return notificationFrequency.sorted { week.firstIndex(of: $0)! < week.firstIndex(of: $1)!}
    }
    
    //MARK: - DatePicker
    
    func createDatePicker() {
        
        timeTextField.textAlignment = .center
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        
        timeTextField.inputAccessoryView = toolBar
        timeTextField.inputView = datePicker
        
        datePicker.datePickerMode = .time
    }
    
    @objc func donePressed() {
        timeTextField.text = "\(datePicker.date.hour())"
        self.view.endEditing(true)
    }
    
    //MARK: - Repeat Frequency TableView
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension WeatherNotificationTimingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeatherNotificationController.shared.daysOfTheWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayOfTheWeekCell", for: indexPath)
        let dow = WeatherNotificationController.shared.daysOfTheWeek[indexPath.row]
        
        cell.textLabel?.text = "Every \(dow)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            guard let day = cell.textLabel?.text else { return }
            weatherNotification?.frequency?.append(day)
            repeatTextField.text = sortWeekdayArray().compactMap({$0}).joined(separator: ",")
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            guard let day = cell.textLabel?.text, let dayIndex = weatherNotification?.frequency?.firstIndex(of: day)
                else { return }
            weatherNotification?.frequency?.remove(at: dayIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let tableViewDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(tableViewDonePressed))
            toolBar.setItems([tableViewDoneButton], animated: true)
            
            repeatTextField.inputAccessoryView = toolBar
            repeatTextField.inputView = daysOfTheWeekTableView
        return toolBar
    }
    
    @objc func tableViewDonePressed() {
        daysOfTheWeekTableView.isHidden = true
        setNotificationButton.isHidden = false
        self.view.endEditing(true)
    }
}
