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
   // var hookahCategories = Products["Tabak"]!
    var hookahCategories = [(key: CategoryModel, value: [ProductModel])]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let hookah = Products["Tabak"]!
        let sortedKeys = hookah.sorted(by: { $0.key.name! < $1.key.name! })
        
        hookahCategories = sortedKeys

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func mixHookah(_ sender: Any) {
        var costlyPrice = 0
        var tabacco = [ProductModel]()
        for i in 0 ..< collectionView.indexPathsForSelectedItems!.count {
            let indexPath = collectionView.indexPathsForSelectedItems![i]
            let key = hookahCategories[indexPath.section]
            let product = key.value[indexPath.row]
            //let key = Array(hookahCategories.keys)[indexPath.section]
            //let products = hookahCategories[key]
           // let product = products![indexPath.row]
            if costlyPrice < product.price! {
                costlyPrice = product.price!
            }
            tabacco.append(product)

        }

        if tabacco.count > 1 {
            showInputDialog(price: costlyPrice, tabacco: tabacco)
        }
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func showInputDialog(price: Int, tabacco: [ProductModel]) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Shisha Mix?", message: "Gebe einen Namen für deinen Mix ein", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "hinzufügen", style: .default) { (_) in
            
            //getting the input values from user
            let name = alertController.textFields?[0].text
            let category = alertController.textFields?[1].text

            
            let hookah = HookahModel()
        
            hookah.id = 0
            hookah.name = name
            hookah.price = Int(price)
            hookah.subCategory = category
            hookah.category = "Hookah"
            hookah.amount = 20
            hookah.count = 0
            let tabaccos = tabacco.compactMap({ (product) -> String? in
                return product.name!
            })
            hookah.details = tabaccos.joined(separator: ", ")
     
            hookah.image = #imageLiteral(resourceName: "blueHookah")
            hookah.tabak = tabacco
            hookah.imagePath = "blueHookah.png"
            hookah.createHookah()
            
            /*var hookahsC = Products["Hookah"]!
            var hookahs = hookahsC["Erfrischend"]!
            hookahs.append(hookah)
            hookahsC.updateValue(hookahs, forKey: "Erfrischend")
            Products.updateValue(hookahsC, forKey: "Hookah")*/
            self.reset()
            
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "abbrechen", style: .cancel) { (_) in
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Name eingeben"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Kategorie eingeben"
            textField.text = "Mix"
            textField.isUserInteractionEnabled = false
        }
        alertController.addTextField { (textField) in
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: price as NSNumber) {
                textField.text = String(formattedTipAmount)
            }
            textField.isUserInteractionEnabled = false
            
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reset(){
        let alert = UIAlertController(title: "Mix erstellt", message: "Dein Mix wurde erfolgreich erstellt.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
        for i in 0 ..< collectionView.indexPathsForSelectedItems!.count {
            let indexPath = collectionView.indexPathsForSelectedItems![i]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCollectionViewCell
            cell.isSelected = false
        }
        collectionView.reloadData()
    }
    
    //MARK UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.allowsMultipleSelection = true
        return hookahCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return hookahCategories[section].value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCollectionViewCell

       // let key = Array(hookahCategories.keys)[indexPath.section]
        let key = hookahCategories[indexPath.section]
        let product = key.value[indexPath.row]
        if key.key.image != nil {
            cell.itemImage.image = key.key.image!
        }
        cell.itemName.text = product.name
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10 // optional
        
        return cell
    }
    
    //Seaction Header View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
        
        let category = hookahCategories[indexPath.section]
      //  let category = Array(hookahCategories.keys)[indexPath.section]
        sectionHeaderView.categoryTitle = category.key.name
        
        return sectionHeaderView
    }

}
class myCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                super.isSelected = true
                self.contentView.backgroundColor = .jugBlue
                self.contentView.tintColor = .jugWhite

            }
            else
            {
                super.isSelected = false
                self.contentView.backgroundColor = .jugWhite
                self.contentView.tintColor = UIColor.black

            }
        }
    }
}
