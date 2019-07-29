//
//  NotesTableViewCell.swift
//  Spartan_MAD4114_IOS_Project
//
//  Created by Owner on 2019-07-28.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var ndatetime: UILabel!
    @IBOutlet weak var ndetail: UILabel!
    @IBOutlet weak var nimage: UIImageView!
    @IBOutlet weak var ntitle: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
