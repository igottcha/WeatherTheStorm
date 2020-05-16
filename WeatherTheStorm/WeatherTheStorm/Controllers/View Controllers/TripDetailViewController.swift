//
//  TripDetailViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/12/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    //MARK: - Properties
    var trip: Trip?
    
    //MARK: - Outlets
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var destinationTextField: UITextField!
    
    //MARK: - Life Cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let destination = destinationTextField.text, !destination.isEmpty else { return }
        
        let startDate = fromDatePicker.date
        let endDate = toDatePicker.date
        
        if let trip = trip , let location = trip.location {
            TripController.shared.updateTrip(withTrip: trip, withStartDate: startDate, withEndDate: endDate, withLocation: location)
        } else {
            LocationController.getPlacemark(searchTerm: destination) { (result) in
                switch result {
                case .success(let placemark):
                    guard let location = LocationController.shared.createLocation(destination: placemark, type: LocationType.trip) else { return }
                    TripController.shared.createTrip(startDate: startDate, endDate: endDate, location: location)
                    WeatherNotificationController.shared.createWeatherNotification(location: location, name: "Trip")
                case .failure(let error):
                    print("Error getting the location of the trip: \(error)")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard let trip = trip else { return }
        fromDatePicker.date = trip.startDate ?? Date()
        toDatePicker.date = trip.endDate ?? Date()
        destinationTextField.text = trip.location?.city ?? ""
    }
}
