//
//  SelectItemViewController.swift
//  ManuHCLHack
//
//  Created by Arpit on 22/07/17.
//  Copyright © 2017 Sayan. All rights reserved.
//

import Foundation
import UIKit

protocol AddBeacon {
    func addBeacon(item: TableItem)
}

class SelectItemViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUUID: UITextField!
    @IBOutlet weak var txtMajor: UITextField!
    @IBOutlet weak var txtMinor: UITextField!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    
    //Check for UUID.
    let uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
    
    var delegate: AddBeacon?
    let allIcons = Icons.allIcons
    var icon = Icons.trophyCabinet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.isEnabled = false
        imgIcon.image = icon.image()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
        //Name and UUID validity check. Advisable not to comment this section even for demo runs. Use this UUID instead: 12345678-1234-1234-123456789012
        let nameValid = (txtName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count > 0)
        
        var uuidValid = false
        let uuidString = txtUUID.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if uuidString.characters.count > 0 {
            uuidValid = (uuidRegex.numberOfMatches(in: uuidString, options: [], range: NSMakeRange(0, uuidString.characters.count)) > 0)
        }
        txtUUID.textColor = (uuidValid) ? .black : .red
        
        // Toggle btnAdd enabled based on valid user entry
        btnAdd.isEnabled = (nameValid && uuidValid)
    }
    
    @IBAction func btnAdd_Pressed(_ sender: UIButton) {
        // Creating new beacon item
        let uuidString = txtUUID.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let uuid = UUID(uuidString: uuidString) else { return }
        let major = Int(txtMajor.text!) ?? 0
        let minor = Int(txtMinor.text!) ?? 0
        let name = txtName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let newItem = TableItem(name: name, icon: icon.rawValue, uuid: uuid, majorValue: major, minorValue: minor)
        
        delegate?.addBeacon(item: newItem)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel_Pressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//CollectionView
extension SelectItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        icon = Icons.icon(forTag: indexPath.row)
        imgIcon.image = icon.image()
    }
}

extension SelectItemViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconTableCell
        cell.icon = allIcons[indexPath.row]
        
        return cell
    }
}

//TextField
extension SelectItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
