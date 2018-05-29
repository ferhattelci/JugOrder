//
//  HookahMixViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 29.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class HookahMixViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //var hookahCategories: [
    var hookahCategories = Products["Tabak"]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func mixHookah(_ sender: Any) {

        for i in 0 ..< collectionView.indexPathsForSelectedItems!.count {
            let indexPath = collectionView.indexPathsForSelectedItems![i]
            let key = Array(hookahCategories.keys)[indexPath.section]
            let products = hookahCategories[key]
            let product = products![indexPath.row]
            

            // determine which product is expensive
            // set this to the input dialog
            // set category
            
        }

        
        showInputDialog()
    }
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Shisha Mix?", message: "Gebe einen Namen für deinen Mix ein", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "hinzufügen", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            let price = alertController.textFields?[1].text
            
           // self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "abbrechen", style: .cancel) { (_) in
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Name eingeben"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Preis eingeben"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.allowsMultipleSelection = true
        return hookahCategories.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        let key = Array(hookahCategories.keys)[section]
        return hookahCategories[key]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCollectionViewCell

        let key = Array(hookahCategories.keys)[indexPath.section]
        let product = hookahCategories[key]
        cell.itemName.text = product![indexPath.row].name
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10 // optional
        
        return cell
    }
    
    //Seaction Header View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
        
        let category = Array(hookahCategories.keys)[indexPath.section]
         sectionHeaderView.categoryTitle = category
        
        return sectionHeaderView
    }

}
class myCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var itemName: UILabel!
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                super.isSelected = true
                self.contentView.backgroundColor = .jugYellow
            }
            else
            {
                super.isSelected = false
                self.contentView.backgroundColor = .jugWhite
            }
        }
    }
}
