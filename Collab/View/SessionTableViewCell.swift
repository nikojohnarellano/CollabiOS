//
//  SessionTableViewCell.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-28.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var sessionOwner: UILabel!
    @IBOutlet weak var sessionDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
