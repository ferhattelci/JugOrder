//
//  ViewTableViewCell.swift
//  JugOrder
//
//  Created by Ferhat Telci on 28.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func tableViewCell(singleTapActionDelegatedFrom cell: ViewTableViewCell)
    func tableViewCell(doubleTapActionDelegatedFrom cell: ViewTableViewCell)
}

class ViewTableViewCell: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDetails: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productAmount: UILabel!
    @IBOutlet weak var productFinished: UIImageView!
    
    private var tapCounter = 0
    var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)

    }
    @objc func tapAction() {
        
        if tapCounter == 0 {
            DispatchQueue.global(qos: .background).async {
                usleep(250000)
                if self.tapCounter > 1 {
                    self.doubleTapAction()
                } else {
                    self.singleTapAction()
                }
                self.tapCounter = 0
            }
        }
        tapCounter += 1
    }
    
    func singleTapAction() {
        delegate?.tableViewCell(singleTapActionDelegatedFrom: self)
    }
    
    func doubleTapAction() {
        delegate?.tableViewCell(doubleTapActionDelegatedFrom: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
