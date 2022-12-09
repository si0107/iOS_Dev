//
//  ChecklistItemCell.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//

import UIKit

class ChecklistItemCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var checkLabel: UIImageView!
    //@IBOutlet var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helper Methods
    func configure(for item: ChecklistItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.itemDescription
        
        switch item.checked{
        case 0:
            if item.category == "Item"{
                checkLabel.image = UIImage(systemName: "circle") // ◯
            } else {
                checkLabel.image = UIImage(systemName: "star") //"☆"
            }
        case 1:
            if item.category == "Item"{
                checkLabel.image = UIImage(systemName: "circle.bottomhalf.filled")//"◒"
            } else {
                checkLabel.image = UIImage(systemName: "star.fill")//"★"
            }
        case 2:
            if item.category == "Item" {
                checkLabel.image = UIImage(systemName: "circle.fill")//"●"
            }
            else {
                checkLabel.image = UIImage(systemName: "star")//"☆"
            }
        default:
            if item.category == "Item"{
                checkLabel.image = UIImage(systemName: "circle")//"◯"
            } else {
                checkLabel.image = UIImage(systemName: "star")//"☆"
            }
        }
    
    }

}
