//
//  TripViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreLocation

class TripDetailViewController: UIViewController {
    
    //MARK: - Properties
    var trip: Trip?
    
    //MARK: - Outlets
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var destinationTextField: UITextField!
    
    //MARK: - Life Cycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let destination = destinationTextField.text, !destination.isEmpty else { return }
        
        let fromDate = fromDatePicker.date
        let toDate = toDatePicker.date
        
        
        if let trip = trip , let location = trip.location {
            TripController.shared.updateTrip(withTrip: trip, withStartDate: fromDate, withEndDate: toDate, withLocation: location)
        } else {
            LocationController.getPlacemark(searchTerm: destination) { (result) in
                switch result {
                case .success(let placemark):
                    let location = Location(destination: placemark, weather: nil)
                    TripController.shared.createTrip(startDate: fromDate, endDate: toDate, location: location)
                case .failure(let error):
                    print("Error getting the location of the trip")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    func updateViews() {
        guard let trip = trip else { return }
        fromDatePicker.date = trip.startDate ?? Date()
        toDatePicker.date = trip.endDate ?? Date()
        destinationTextField.text = trip.location?.destination?.locality ?? ""
    }
    

}
