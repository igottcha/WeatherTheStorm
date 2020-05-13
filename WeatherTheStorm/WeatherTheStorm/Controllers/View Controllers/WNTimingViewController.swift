//
//  WNTimingViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class WNTimingViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var addNotificationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!
    @IBOutlet weak var tableViewToolBar: UIToolbar!
    @IBOutlet weak var daysOfTheWeekTableView: UITableView!
    @IBOutlet weak var setNotificationButton: UIButton!
    
    //MARK: - Properties
    
    var location: Location?
    var section: String?
    let datePicker = UIDatePicker()
    
    //MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysOfTheWeekTableView.isHidden = true
        daysOfTheWeekTableView.delegate = self
        daysOfTheWeekTableView.dataSource = self
        updateView()
        createDatePicker()
        setNotificationButton.layer.cornerRadius = 7
        setNotificationButton.isHidden = true
    }
    
    //MARK: - Actions
    
    @IBAction func repeatTextFieldDidBeginEditing(_ sender: UITextField) {
        daysOfTheWeekTableView.isHidden = false
    }
    @IBAction func setNotificationButtonTapped(_ sender: UIButton) {
        guard let location = location, let weatherNotification = location.weatherNotification?.firstObject as? WeatherNotification else { return }
        let frequency = sortWeekdayArray()
        WeatherNotificationController.shared.updateWeatherNotification(weatherNotification: weatherNotification, isActive: true, frequency: frequency, specificDate: nil, time: datePicker.date)
        setAlertNotification(location: location)
        print(WeatherNotificationController.shared.fetchedResultsController.fetchedObjects?.count)
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                print("successfully dismissed")
            }
            //self.navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func tableViewDoneButtonTapped(_ sender: UIBarButtonItem) {
        daysOfTheWeekTableView.isHidden = true
        setNotificationButton.isHidden = false
        self.view.endEditing(true)
        repeatTextField.text = "Every \(sortWeekdayArray().compactMap({$0}).joined(separator: ", "))"
    }
    
    
    //MARK: - Methods
    
    func sortWeekdayArray() -> [String] {
        guard let week = DateFormatter().weekdaySymbols else { return [] }
        let frequencies = WeatherNotificationController.shared.frequencies
        return frequencies.sorted { week.firstIndex(of: $0)! < week.firstIndex(of: $1)!}
    }
    
    func updateView() {
        guard let section = section, let city = location?.destination?.locality, let state = location?.destination?.administrativeArea, let country = location?.destination?.country else { return }
        addNotificationLabel.text = "Add \(section) Notification"
        addressLabel.text = "\(city), \(state), \(country)"
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
    
    //MARK: - Notification Alert Controller
    
    func setAlertNotification(location: Location) {
        guard let weatherNotification = location.weatherNotification?.firstObject as? WeatherNotification, let weather = location.weather, let weatherPhrase = weather.current?.phrase, let feelsLikeTemp = weather.current?.feelsLike, let city = location.destination?.locality else { return }
        let clothingPhrase = "CLOTHING STRING PLACEHOLDER"
        let notificationText = "Hi \(UserController.shared.userName), It's \(weatherPhrase) today in \(city). Feels like \(feelsLikeTemp)°. You'll want to \(clothingPhrase)."
        
        let alert = UIAlertController(title: weatherNotification.name, message: notificationText, preferredStyle: .alert)
        
        let closeButton = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alert.addAction(closeButton)
        self.present(self, animated: true, completion: nil)
    }
    
}

extension WNTimingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DateFormatter().calendar.weekdaySymbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayOfTheWeekCell", for: indexPath)
        let dow = DateFormatter().calendar.weekdaySymbols[indexPath.row]
        
        cell.textLabel?.text = "Every \(dow)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
            cell.accessoryView?.tintColor = .black
            guard let cellText = cell.textLabel?.text else { return }
            let day = cellText.replacingOccurrences(of: "Every ", with: "")
            WeatherNotificationController.shared.frequencies.append(day)
            
            //frequencies.append(day)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
            cell.accessoryView?.tintColor = .black
            var frequencies = WeatherNotificationController.shared.frequencies
            guard let day = cell.textLabel?.text,let dayIndex = frequencies.firstIndex(of: day)
                else { return }
            frequencies.remove(at: dayIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
  
        tableViewToolBar.barTintColor = .systemRed
        tableViewToolBar.tintColor = .black
        
        let tableViewDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(tableViewDonePressed))
        tableViewToolBar.setItems([tableViewDoneButton], animated: true)
        
        repeatTextField.textAlignment = .left
        repeatTextField.inputAccessoryView = tableViewToolBar
        repeatTextField.inputView = daysOfTheWeekTableView
        return tableViewToolBar
    }
    
    @objc func tableViewDonePressed() {
        daysOfTheWeekTableView.isHidden = true
        setNotificationButton.isHidden = false
        self.view.endEditing(true)
    }
}
