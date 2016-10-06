//
//  StatisticsViewController.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 9/30/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

let cellIdentifier = "statisticCell"

class StatisticsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberStatisticsTableView: UITableView!
    @IBOutlet weak var showcaseTableView: ShowcaseTableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var entityTypePicked: EntityType!
    
    let swapiClient = SWAPIClient()
    
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
        
        navigationItem.title = entityTypePicked.rawValue
        
        memberStatisticsTableView.dataSource = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        showcaseTableView.dataSource = showcaseTableView
        
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked else { fatalError() }
        
        switch entityTypePicked {
        case .Characters:
            swapiClient.fetchCharacters { result in
                switch result {
                case .Success(let characters): self.characters.appendContentsOf(characters)
                case .Failure(let error): print(error)
                }
            }
        case .Vehicles:
            swapiClient.fetchVehicles { result in
                switch result {
                case .Success(let vehicles): self.vehicles.appendContentsOf(vehicles)
                case .Failure(let error): print(error)
                }
            }
        case .Starships:
            swapiClient.fetchStarships { result in
                switch result {
                case .Success(let starships): self.starships.appendContentsOf(starships)
                case .Failure(let error): print(error)
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? StatisticTableViewCell else {
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
                    cell.valueLabel.text = character.home.capitalizedString
                case 2:
                    cell.keyLabel.text = "Height"
                    cell.size = character.height
                case 3:
                    cell.keyLabel.text = "Eyes"
                    cell.valueLabel.text = character.eyes.capitalizedString
                case 4:
                    cell.keyLabel.text = "Hair"
                    cell.valueLabel.text = character.hair.capitalizedString
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
                case 2:
                    cell.keyLabel.text = "Length"
                    cell.size = vehicle.length
                case 3:
                    cell.keyLabel.text = "Class"
                    cell.valueLabel.text = vehicle.`class`.capitalizedString
                case 4:
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
                case 2:
                    cell.keyLabel.text = "Length"
                    cell.size = starship.length
                case 3:
                    cell.keyLabel.text = "Class"
                    cell.valueLabel.text = starship.`class`.capitalizedString
                case 4:
                    cell.keyLabel.text = "Crew"
                    cell.valueLabel.text = starship.crew
                default: break
                }
            }
        }
        
        return cell
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
