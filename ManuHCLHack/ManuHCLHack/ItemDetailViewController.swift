//
//  ItemDetailViewController.swift
//  ManuHCLHack
//
//  Created by Arpit on 22/07/17.
//  Copyright © 2017 Sayan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AVKit
import AVFoundation

let storedItemsKey = "storedItems"

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var items = [TableItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        loadItems()
    }
    
    //Loading Item data
    func loadItems() {
        guard let storedItems = UserDefaults.standard.array(forKey: storedItemsKey) as? [Data] else { return }
        for itemData in storedItems {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? TableItem else { continue }
            items.append(item)
            startMonitoringItem(item)
        }
    }
    
    //Storing Item Preferences
    func persistItems() {
        var itemsData = [Data]()
        for item in items {
            let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
            itemsData.append(itemData)
        }
        UserDefaults.standard.set(itemsData, forKey: storedItemsKey)
        UserDefaults.standard.synchronize()
    }
    
    //Moving from first to second screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAdd", let viewController = segue.destination as? SelectItemViewController {
            viewController.delegate = self
        }
    }
    
    //Beacon Monitoring functions
    func startMonitoringItem(_ item: TableItem) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopMonitoringItem(_ item:TableItem) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
}

extension ItemDetailViewController: AddBeacon {
    //Updating tableView with new rows depending on beacons
    func addBeacon(item: TableItem) {
        items.append(item)
        
        tableView.beginUpdates()
        let newIndexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
        startMonitoringItem(item)
        persistItems()
    }
}

//DataSource functions
extension ItemDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        cell.item = items[indexPath.row]
        stopMonitoringItem(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            persistItems()
        }
    }
}

//Delegate functions
extension ItemDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let item = items[indexPath.row]
//        let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
//        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
//        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(detailAlert, animated: true, completion: nil)
        
        
        //Added one video for demo. Multiple videos based on beacon can be included by checking Minor value in a if-loop
        playVideo(mediaVar: "mufc", mediaType: "mp4")
    }
    
    func playVideo(mediaVar: String, mediaType: String){
        guard let path = Bundle.main.path(forResource: mediaVar, ofType: mediaType) else {
            debugPrint("mufc.mp4 not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}

extension ItemDetailViewController: CLLocationManagerDelegate {
    
    //Error Check
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error){
//        print("Failed")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
//        print("Failed")
    }
    
    //Updating table with beacon details
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        var indexPaths = [IndexPath]()
        for beacon in beacons{
            for row in 0..<items.count{
                if items[row] == beacon {
                    items[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
            }
        }
        
        if let visibleRows = tableView.indexPathsForVisibleRows{
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0)}
            for row in rowsToUpdate{
                let cell = tableView.cellForRow(at: row) as! ItemCell
                cell.refreshLocation()
            }
        }
    }
}
