//
//  AllListsCell.swift
//  ToDoApp
//
//  Created by S I on 12/9/22.
//

import UIKit

class AllListsCell: UITableViewCell {
    
    @IBOutlet var allListsTitleLabel: UILabel!
    @IBOutlet var numberOfItemsLabel: UILabel!
    @IBOutlet var allListIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helper Methods
    func configure(for list: Checklist) {
        allListsTitleLabel.text = list.name
        allListIcon.image = UIImage(named: list.listIconName)
        let listCount = list.listOfItems.count
        numberOfItemsLabel.text = "\(listCount) items"
    }
    

}
