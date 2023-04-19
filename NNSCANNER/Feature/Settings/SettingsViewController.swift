//
//  SettingsViewController.swift
//  NNSCANNER
//
//  Created by Nhat on 18/04/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet  weak var defaultPageSwitch: UISwitch!
    @IBOutlet  weak var a4PageSwitch: UISwitch!
    @IBOutlet  weak var simplePageSwitch: UISwitch!

    @IBOutlet  weak var croppedModeSwitch: UISwitch!
    @IBOutlet  weak var enhanceModeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSwitchValuesFromUserDefaults()
    }

    private func updateSwitchValuesFromUserDefaults() {
        let docMode = UserDefaults.standard.integer(forKey: "DocMode")
        let scanMode = UserDefaults.standard.integer(forKey: "ScanMode")
        switch docMode {
        case 1:
            defaultPageSwitch.isOn = true
            a4PageSwitch.isOn = false
            simplePageSwitch.isOn = false
        case 2:
            defaultPageSwitch.isOn = false
            a4PageSwitch.isOn = true
            simplePageSwitch.isOn = false
        case 3:
            defaultPageSwitch.isOn = false
            a4PageSwitch.isOn = false
            simplePageSwitch.isOn = true
        default:
            break
        }

        switch scanMode {
        case 1:
            croppedModeSwitch.isOn = true
            enhanceModeSwitch.isOn = false
        case 2:
            croppedModeSwitch.isOn = false
            enhanceModeSwitch.isOn = true
        default:
            break
        }
    }

    @IBAction func switchValueChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        var docMode = UserDefaults.standard.integer(forKey: "DocMode")
        var scanMode = UserDefaults.standard.integer(forKey: "ScanMode")
        switch sender {
            case defaultPageSwitch:
                if sender.isOn {
                    a4PageSwitch.isOn = false
                    simplePageSwitch.isOn = false
                    docMode = 1
                } else if !a4PageSwitch.isOn && !simplePageSwitch.isOn {
                    defaultPageSwitch.isOn = true
                }
            case a4PageSwitch:
                if sender.isOn {
                    defaultPageSwitch.isOn = false
                    simplePageSwitch.isOn = false
                    docMode = 2
                } else if !defaultPageSwitch.isOn && !simplePageSwitch.isOn {
                    a4PageSwitch.isOn = true
                }
            case simplePageSwitch:
                if sender.isOn {
                    defaultPageSwitch.isOn = false
                    a4PageSwitch.isOn = false
                    docMode = 3
                } else if !defaultPageSwitch.isOn && !a4PageSwitch.isOn {
                    simplePageSwitch.isOn = true
                }
            case croppedModeSwitch:
                if sender.isOn {
                    enhanceModeSwitch.isOn = false
                    scanMode = 1
                } else if !enhanceModeSwitch.isOn {
                    croppedModeSwitch.isOn = true
                }
            case enhanceModeSwitch:
                if sender.isOn {
                    croppedModeSwitch.isOn = false
                    scanMode = 2
                } else if !croppedModeSwitch.isOn {
                    enhanceModeSwitch.isOn = true
                }
            default:
                break
        }
        UserDefaults.standard.set(docMode, forKey: "DocMode")
        UserDefaults.standard.set(scanMode, forKey: "ScanMode")
    }
    
}

