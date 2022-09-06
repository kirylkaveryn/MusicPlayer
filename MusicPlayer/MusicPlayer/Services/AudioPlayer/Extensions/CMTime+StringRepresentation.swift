//
//  CMTime+StringRepresentation.swift
//  MusicPlayer
//
//  Created by Kirill on 5.09.22.
//

import Foundation
import AVKit

extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours:  Int { return Int(roundedSeconds / 3600) }
    var minute: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60) }
    var second: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 60)) }
    var positionalTime: String {
        return hours > 0 ?
            String(format: "%d:%01d:%02d",
                   hours, minute, second) :
            String(format: "%01d:%02d",
                   minute, second)
    }
}
