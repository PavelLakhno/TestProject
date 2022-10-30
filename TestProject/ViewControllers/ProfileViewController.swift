//
//  ProfileViewController.swift
//  TestProject
//
//  Created by Павел on 28.10.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setupSettingsTo(user: User)
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var economyTime: UILabel!
    @IBOutlet weak var economyMoney: UILabel!
    @IBOutlet weak var passCigaretts: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!
    
    var user: User!
    
    var timer = Timer()
    var count = 0
    var timerCounting = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Profile"
        startStopTimer(timerCounting)
        count = getTimeIntervalFrom(date: user.person.dateQuitSmoke)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.user = user
            settingsVC.delegate = self
        }
    }

    // MARK: IBActions
    @IBAction func startStopTapped(_ sender: UIButton) {        
        if (timerCounting) {
            giveUp()
            timerCounting = false
            startStopTimer(timerCounting)
            startStopButton.setTitle("Бросаю", for: .normal)
            startStopButton.setTitleColor(UIColor.white, for: .normal)
            
        } else {
            timerCounting = true
            startStopTimer(timerCounting)
            startStopButton.setTitle("Сдаюсь", for: .normal)
            startStopButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    // MARK: Private Methods
    private func startStopTimer(_ isValue: Bool) {
        if isValue {
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(timerCounter),
                userInfo: nil,
                repeats: true
            )
        } else {
            timer.invalidate()
        }
    }

    func giveUp() {
            self.user.person.dateQuitSmoke = Date()
            self.user.person.amountCigarettsDay = 1
            self.user.person.amountCigarettsBox = 1
            self.user.person.priceBoxCigaretts = 1
            self.user.person.timeForSmoke = 1
            self.count = 0
            self.economyTime.text = "0 руб"
            self.economyMoney.text = "0 руб"
            self.passCigaretts.text = "0 шт"
            self.daysLabel.text = "0"
            self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            startStopButton.isEnabled = false
    }
    
        
    @objc func timerCounter() {
        count += 1
        let time = secondsToDaysHoursMinutesSeconds(seconds: count)
        let dayString = "\(time.0)"
        let timeString = makeTimeString(hours: time.1, minutes: time.2, seconds: time.3)
        daysLabel.text = dayString
        timerLabel.text = timeString
        economyTime.text = getEconomyTime()
        economyMoney.text = getEconomyMoney()
        passCigaretts.text = getCountNoSmokeCig()
    }
    
    
    private func secondsToDaysHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int, Int) {
        let restSeconds = seconds % 86400
        return ((seconds / 86400), (restSeconds / 3600), ((restSeconds % 3600) / 60), ((restSeconds % 3600) % 60))
    }
    
    
    private func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    private func makeDayString(seconds: Int) -> String {
        "\((seconds / 86400))"
    }
    
    private func getTimeIntervalFrom(date: Date) -> Int {
        Int(Date().timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate)
    }
    
    private func getEconomyTime() -> String {
        print(count)
        return "\((count) / (user.person.timeForSmoke * 60) / 60) мин"
    }

    private func getEconomyMoney() -> String {
        let priceOneCigar = user.person.priceBoxCigaretts / user.person.amountCigarettsBox
        let spendMoneyOneDay = priceOneCigar * user.person.amountCigarettsDay
        let totalEconomyMoney = "\(count / 86400 * spendMoneyOneDay) руб"
        return totalEconomyMoney
    }
    
    private func getCountNoSmokeCig() -> String{
        "\(count / 86400 * user.person.amountCigarettsDay) шт"
    }
   
}


extension ProfileViewController : SettingsViewControllerDelegate {
    func setupSettingsTo(user: User) {
        self.user = user
        count = getTimeIntervalFrom(date: user.person.dateQuitSmoke)
        startStopButton.isEnabled = true
    }
}
