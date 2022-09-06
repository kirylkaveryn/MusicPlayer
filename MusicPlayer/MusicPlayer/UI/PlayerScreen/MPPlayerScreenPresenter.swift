//
//  MPPlayerScreenPresenter.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVKit

enum MPTrackSelecion {
    case next, previous, index(Int)
}

enum MPTrackPlayback {
    case play, pause
}

protocol MPPlayerScreenPresenterProtocol: AnyObject {
    var tracksCount: Int { get }
    var tracksImages: [UIImage] { get }

    var trackDidChange: ((String, String) -> ())? { get set }
    var progressDidChange: ((Progress) -> ())? { get set }

    func fetchTracks()
    func setPlayback(_ playback: MPTrackPlayback)
    func goToTrack(_ track: MPTrackSelecion)
}

class MPPlayerScreenPresenter: MPPlayerScreenPresenterProtocol {
    
    private var resourсeService: MPResourсeServiceProtocol
    private var audioPlayer: MPAudioPlayerProtocol
   
    var tracksCount: Int {
        get {
            audioPlayer.tracks.count
        }
    }
    
    var tracksImages: [UIImage] {
        get {
            audioPlayer.tracks.map { $0.artwork }
        }
    }

    var trackDidChange: ((String, String) -> ())?
    var progressDidChange: ((Progress) -> ())?

    init(resourceService: MPResourсeServiceProtocol, audioPlayer: MPAudioPlayerProtocol) {
        self.resourсeService = resourceService
        self.audioPlayer = audioPlayer
        
        // setup binding closures
        self.audioPlayer.trackDidChange = { [weak self] trackModel in
            guard let self = self else { return }
            self.trackDidChange?(trackModel.title, trackModel.artist)
        }
        self.audioPlayer.progressDidChange = { [weak self] progress in
            guard let self = self else { return }
            self.progressDidChange?(progress)
        }
    }
    
    func fetchTracks() {
        guard let tracksURLs = resourсeService.fetchTracksURL() else { return }
        audioPlayer.setupPlayer(tracksURLs: tracksURLs)
    }
    
    func setPlayback(_ playback: MPTrackPlayback) {
        switch playback {
        case .play:
            audioPlayer.play()
        case .pause:
            audioPlayer.pause()
        }
    }

    func goToTrack(_ track: MPTrackSelecion) {
        switch track {
        case .next:
            audioPlayer.goForward()
        case .previous:
            audioPlayer.goBack()
        case .index(let index):
            audioPlayer.goToTrack(index: index)
        }
    }
}
