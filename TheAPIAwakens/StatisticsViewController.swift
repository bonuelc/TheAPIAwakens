//
//  StatisticsViewController.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 9/30/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

protocol ExchangeRateDelegate {
    var exchangeRate: Double { get set }
}

let statisticCellIdentifier = "statisticCell"
let conversionCellIdentifier = "conversionCell"
let ridesCellIdentifier = "ridesCell"

extension Array {
    var secondToLast: Element? {
        if self.count > 1 {
            return self[self.count - 2]
        }
        
        return nil
    }
}

class StatisticsViewController: UIViewController, ExchangeRateDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberStatisticsTableView: UITableView!
    @IBOutlet weak var showcaseTableView: ShowcaseTableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var entityTypePicked: EntityType!
    
    let swapiClient = SWAPIClient()
    var exchangeRate: Double = 1.01 {
        didSet {
            memberStatisticsTableView.reloadData()
        }
    }
    
    var characters: [Character] = [] {
        didSet {
            memberStatisticsTableView.reloadData()
            pickerView.reloadAllComponents()
            nameLabel.text = characters[pickerView.selectedRowInComponent(0)].name
            
            let charactersWithKnownSize = characters.filter{ $0.size != nil }
            showcaseTableView.smallest = charactersWithKnownSize.minElement { $0.size < $1.size }
            showcaseTableView.largest = charactersWithKnownSize.maxElement { $0.size < $1.size }
            showcaseTableView.reloadData()
        }
    }
    
    var vehicles: [Vehicle] = [] {
        didSet {
            memberStatisticsTableView.reloadData()
            pickerView.reloadAllComponents()
            nameLabel.text = vehicles[pickerView.selectedRowInComponent(0)].name
            
            let vehiclesWithKnownSize = vehicles.filter{ $0.size != nil }
            showcaseTableView.smallest = vehiclesWithKnownSize.minElement { $0.size < $1.size }
            showcaseTableView.largest = vehiclesWithKnownSize.maxElement { $0.size < $1.size }
            showcaseTableView.reloadData()
        }
    }
    
    var starships: [Starship] = [] {
        didSet {
            memberStatisticsTableView.reloadData()
            pickerView.reloadAllComponents()
            nameLabel.text = starships[pickerView.selectedRowInComponent(0)].name
            
            let starshipsWithKnownSize = starships.filter{ $0.size != nil }
            showcaseTableView.smallest = starshipsWithKnownSize.minElement { $0.size < $1.size }
            showcaseTableView.largest = starshipsWithKnownSize.maxElement { $0.size < $1.size }
            showcaseTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // avoid 'index out of range error' before data fetch is complete
        pickerView.userInteractionEnabled = false
        
        navigationItem.title = entityTypePicked.rawValue
        
        memberStatisticsTableView.dataSource = self
        memberStatisticsTableView.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        showcaseTableView.dataSource = showcaseTableView
        
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked else { fatalError() }
        
        switch entityTypePicked {
        case .Characters: fetchCharacters()
        case .Vehicles: fetchVehicles()
        case .Starships: fetchStarships()
        }
        
        pickerView.userInteractionEnabled = true
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let ridesVC = segue.destinationViewController as? RidesViewController {
            ridesVC.character = characters[pickerView.selectedRowInComponent(0)]
        }
    }
    
    func presentAlertController(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .Default) { [weak self] _ in
            guard let navController = self!.navigationController else {
                return
            }
            
            navController.popViewControllerAnimated(true)
        }
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func fetchCharacters(apiPageIndex: Int = 1) {
        swapiClient.fetchCharacters(apiPageIndex) { result in
            switch result {
            case .Success(let characters):
                 self.characters.appendContentsOf(characters)
                self.fetchCharacters(apiPageIndex + 1)
            case .Failure(let error as NSError):
                if apiPageIndex == 1 {
                    self.presentAlertController("Unable to retrieve \(self.entityTypePicked.rawValue.lowercaseString)", message: error.localizedDescription)
                }
            default: break // TODO: why does the compiler think this is necessary?
            }
        }
    }
    
    func fetchVehicles(apiPageIndex: Int = 1) {
        swapiClient.fetchVehicles(apiPageIndex) { result in
            switch result {
            case .Success(let vehicles):
                self.vehicles.appendContentsOf(vehicles)
                self.fetchVehicles(apiPageIndex + 1)
            case .Failure(let error as NSError):
                if apiPageIndex == 1 {
                    self.presentAlertController("Unable to retrieve \(self.entityTypePicked.rawValue.lowercaseString)", message: error.localizedDescription)
                }
            default: break // TODO: why does the compiler think this is necessary?
            }
        }
    }
    
    func fetchStarships(apiPageIndex: Int = 1) {
        swapiClient.fetchStarships(apiPageIndex) { result in
            switch result {
            case .Success(let starships):
                self.starships.appendContentsOf(starships)
                self.fetchStarships(apiPageIndex + 1)
            case .Failure(let error as NSError):
                if apiPageIndex == 1 {
                    self.presentAlertController("Unable to retrieve \(self.entityTypePicked.rawValue.lowercaseString)", message: error.localizedDescription)
                }
            default: break // TODO: why does the compiler think this is necessary?
            }
        }
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(statisticCellIdentifier) as? StatisticTableViewCell else {
            return UITableViewCell()
        }
        
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked else { fatalError() }
        
        switch entityTypePicked {
        case .Characters:
            if characters.count != 0 {
                let character = characters[pickerView.selectedRowInComponent(0)]
                switch indexPath.row {
                case 0:
                    cell.keyLabel.text = "Born"
                    cell.valueLabel.text = character.born
                case 1:
                    cell.keyLabel.text = "Home"
                    
                    guard let planetNumber = character.home.componentsSeparatedByString("/").secondToLast, apiIndex = Int(planetNumber) else {
                        cell.valueLabel.text = "unknown"
                        return cell
                    }
                    
                    swapiClient.fetchPlanet(apiIndex) { result in
                        switch result {
                        case .Success(let planet): cell.valueLabel.text = planet.name
                        case .Failure(let error): print(error)
                        }
                    }
                case 2:
                    cell.keyLabel.text = "Height"
                    cell.size = character.height
                case 3:
                    cell.keyLabel.text = "Eyes"
                    cell.valueLabel.text = character.eyes.capitalizedString
                case 4:
                    cell.keyLabel.text = "Hair"
                    cell.valueLabel.text = character.hair.capitalizedString
                case 5:
                    guard let cell = tableView.dequeueReusableCellWithIdentifier(ridesCellIdentifier) else {
                        return UITableViewCell()
                    }
                    return cell
                default: break
                }
            }
        case .Vehicles:
            if vehicles.count != 0 {
                let vehicle = vehicles[pickerView.selectedRowInComponent(0)]
                switch indexPath.row {
                case 0:
                    cell.keyLabel.text = "Make"
                    cell.valueLabel.text = vehicle.make.capitalizedString
                case 1:
                    cell.keyLabel.text = "Cost"
                    cell.cost = vehicle.cost
                    cell.exchangeRate = exchangeRate
                case 2:
                    guard let cell = tableView.dequeueReusableCellWithIdentifier(conversionCellIdentifier) as? ConversionTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.delegate = self
                    return cell
                case 3:
                    cell.keyLabel.text = "Length"
                    cell.size = vehicle.length
                case 4:
                    cell.keyLabel.text = "Class"
                    cell.valueLabel.text = vehicle.`class`.capitalizedString
                case 5:
                    cell.keyLabel.text = "Crew"
                    cell.valueLabel.text = vehicle.crew
                default: break
                }
            }
        case .Starships:
            if starships.count != 0 {
                let starship = starships[pickerView.selectedRowInComponent(0)]
                switch indexPath.row {
                case 0:
                    cell.keyLabel.text = "Make"
                    cell.valueLabel.text = starship.make.capitalizedString
                case 1:
                    cell.keyLabel.text = "Cost"
                    cell.cost = starship.cost
                    cell.exchangeRate = exchangeRate
                case 2:
                    guard let cell = tableView.dequeueReusableCellWithIdentifier(conversionCellIdentifier) as? ConversionTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.delegate = self
                    return cell
                case 3:
                    cell.keyLabel.text = "Length"
                    cell.size = starship.length
                case 4:
                    cell.keyLabel.text = "Class"
                    cell.valueLabel.text = starship.`class`.capitalizedString
                case 5:
                    cell.keyLabel.text = "Crew"
                    cell.valueLabel.text = starship.crew
                default: break
                }
            }
        }
        
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let _ = tableView.dequeueReusableCellWithIdentifier(ridesCellIdentifier) else {
            return
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("ridesSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked where entityTypePicked == .Characters else { return false }
        
        return indexPath.row == 5
    }
}

extension StatisticsViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked else { fatalError() }
        
        switch entityTypePicked {
        case .Characters: return characters.count
        case .Vehicles: return vehicles.count
        case .Starships: return starships.count
        }
    }
}

extension StatisticsViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked else { fatalError() }
        
        switch entityTypePicked {
        case .Characters: return characters[row].name
        case .Vehicles: return vehicles[row].name
        case .Starships: return starships[row].name
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked else { fatalError() }
        
        switch entityTypePicked {
        case .Characters: nameLabel.text = characters[row].name
        case .Vehicles: nameLabel.text = vehicles[row].name
        case .Starships: nameLabel.text = starships[row].name
        }
        
        memberStatisticsTableView.reloadData()
    }
}
