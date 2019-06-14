//
//  Separator.swift
//  Weather
//
//  Created by Romit on 14/06/19.
//  Copyright © 2019 Romit. All rights reserved.
//

import UIKit

class HorizontalSeparator: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	override func awakeFromNib() {
		super.awakeFromNib()
		self.backgroundColor = UIColor.lightGray
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		var rect : CGRect = self.frame
		rect.size.height = 0.5
		self.frame = rect
	}
}
