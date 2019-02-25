//
//  ViewController.swift
//  ConvertIt
//
//  Created by Timothy Yang on 2/24/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    var formulaArray = ["miles to kilometers",
                        "kilometers to miles",
                        "feet to meters",
                        "yards to meters",
                        "meters to feet",
                        "meters to yards",
                        "inches to cm",
                        "cm to inches",
                        "fahrenheit to celcius",
                        "celcius to fahrenheit",
                        "quarts to liters",
                        "liters to quarts"]
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        signSegment.isHidden = true
        formulaPicker.delegate = self
        formulaPicker.delegate = self
        conversionString = formulaArray[formulaPicker.selectedRow(inComponent: 0)]
        userInput.becomeFirstResponder()

    }

    func calculateConversion(){
        guard let inputValue = Double(userInput.text!) else {
            showAlert(title: "Cannot Convert Value", message: "\(userInput.text!) is not a valid number")
            return
        }
        var outputValue = 0.0

        switch conversionString {
        case "miles to kilometers":
            outputValue = inputValue / 0.62137
        case "kilometers to miles":
            outputValue = inputValue * 0.62137
        case "feet to meters":
            outputValue = inputValue / 3.2808
        case "yards to meters":
            outputValue = inputValue / 1.0936
        case "meters to feet":
            outputValue = inputValue * 3.2808
        case "meters to yards":
            outputValue = inputValue * 1.0936
        case "inches to cm":
            outputValue = inputValue / 0.3937
        case "cm to inches":
            outputValue = inputValue * 0.3937
        case "fahrenheit to celcius":
            outputValue = (inputValue - 32) * 5/9
        case "celcius to fahrenheit":
            outputValue = inputValue * 9/5 + 32
        case "quarts to liters":
            outputValue = inputValue / 1.05669
        case "liters to quarts":
            outputValue = inputValue * 1.05669
            
            
            
            
        default:
            showAlert(title: "Unexcpected Error", message: "Contact the developer and share that \"\(conversionString)\" could not be identified.")
        }
        let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments-1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f" : "%f")
        let outputString = String(format: formatString, outputValue)
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"

        
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func userInputChanged(_ sender: Any) {
        resultsLabel.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func signSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0 {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        if userInput.text != "-" {
            calculateConversion()
        }
    }
    
    @IBAction func decimalSelected(_ sender: Any) {
        calculateConversion()
    }
    
    @IBAction func convertButtonPressed(_ sender: Any) {
        calculateConversion()
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulaArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionString = formulaArray[row]
        if conversionString.lowercased().contains("celcius".lowercased()) {
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        }
        let unitsArray = formulaArray[row].components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        resultsLabel.text = toUnits
        calculateConversion()
    }
    
}

