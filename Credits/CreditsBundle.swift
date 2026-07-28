//
//  CreditsBundle.swift
//  Credits
//
//  Created by Bank Indonesia on 27/07/26.
//

import WidgetKit
import SwiftUI

@main
struct CreditsBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WidgetBundleBuilder.buildBlock(Credits())
//        Credits()
//        CreditsLiveActivity()
    }
}
