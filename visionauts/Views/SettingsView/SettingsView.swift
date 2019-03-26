//
//  SettingsView.swift
//  visionauts
//
//  Created by Renata Makuch on 20/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit
import Foundation

class SettingsView: BaseNibView, UITextFieldDelegate {

    @IBOutlet weak var voiceOverLabel: UILabel!
    @IBOutlet weak var voiceOverStatusLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var rangeTextField: UITextField!
    @IBOutlet weak var rangeSlider: CustomSlider!
    
    var viewModel: SettingsViewModel!
    
    override func setViewApperance() {
        rangeTextField.delegate = self
        setupViewModel()
        setupAccessibility()
        addDoneButton()
        setupView()
    }
    
    func setupViewModel() {
        viewModel = SettingsViewModel(ServiceFactory.settingsService)
        viewModel.setVoiceOverStatus = {  (color, text)  in
            self.voiceOverStatusLabel.text = text
            self.voiceOverStatusLabel.textColor = color
            self.voiceOverStatusLabel.backgroundColor = color.withAlphaComponent(0.2)
            self.voiceOverStatusLabel.accessibilityLabel = text
        }
        
        viewModel.updateView = {
            self.rangeSlider.setValue(self.viewModel.currentRange, animated: false)
            if !self.rangeTextField.isFirstResponder {
                self.rangeTextField.text = self.viewModel.getTextFromValue(self.viewModel.currentRange)
            }
        }
    }
    
    func setupView(){
        let range = viewModel.getCurrentRange()
        rangeSlider.setValue(range, animated: false)
        rangeTextField.text = viewModel.getTextFromValue(range)
        viewModel.getVoiceOverStatus(UIAccessibility.isVoiceOverRunning)
    }

    func setupAccessibility() {
        voiceOverLabel.accessibilityLabel = NSLocalizedString("VoiceOverFunctionDescription", comment: "")
        rangeLabel.accessibilityLabel = NSLocalizedString("BluetoothScanningRangeDescription", comment: "")
    }
    
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.barTintColor = UIColor.white
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.blue
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneButtonTap))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        rangeTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonTap(){
        rangeTextField.resignFirstResponder()
    }
    
    @IBAction func rangeChanged(_ sender: UISlider) {
        let _ = viewModel.saveRange(sender.value)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newText = NSString(string: text).replacingCharacters(in: range, with: string)
        
        let value = viewModel.getValueFromText(newText)
        return viewModel.saveRange(value)
    }
}
