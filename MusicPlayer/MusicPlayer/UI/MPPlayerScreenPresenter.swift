//
//  MPPlayerScreenPresenter.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVKit


protocol MPPlayerScreenPresenterProcol: AnyObject {
    var songs: [MPSongModel] { get }
    var songDidChange: ((MPSongModel) -> ())? { get set }
    
    func playButtonDidTap()
    func pauseButtonDidTap()
    func backwardButtonDidTap()
    func forwardButtonDidTap()
}

class MPPlayerScreenPresenter: MPPlayerScreenPresenterProcol {
    
    private var audioPlayer: MPAudioPlayerProtocol
   
    var songs: [MPSongModel] {
        get {
            audioPlayer.songs
        }
    }

    var songDidChange: ((MPSongModel) -> ())?
    
    init(audioPlayer: MPAudioPlayerProtocol) {
        self.audioPlayer = audioPlayer
        self.audioPlayer.songDidChange = { [weak self] songModel in
            guard let self = self else { return }
            self.songDidChange?(songModel)
        }
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
