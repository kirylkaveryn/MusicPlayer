//
//  MPPlayerScreenPresenter.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVKit


protocol MPPlayerScreenPresenterProcol: AnyObject {
    func playButtonDidTap()
    func pauseButtonDidTap()
    func backwardButtonDidTap()
    func forwardButtonDidTap()
}

class MPPlayerScreenPresenter: MPPlayerScreenPresenterProcol {

    private var audioPlayer: MPAudioPlayerProtocol
    
    init(audioPlayer: MPAudioPlayerProtocol) {
        self.audioPlayer = audioPlayer
    }

    
    func playButtonDidTap() {
        audioPlayer.play()
    }
    
    func pauseButtonDidTap() {
        audioPlayer.pause()
    }
    
    func backwardButtonDidTap() {
        audioPlayer.goBack()
    }
    
    func forwardButtonDidTap() {
        audioPlayer.goForward()
    }
}
