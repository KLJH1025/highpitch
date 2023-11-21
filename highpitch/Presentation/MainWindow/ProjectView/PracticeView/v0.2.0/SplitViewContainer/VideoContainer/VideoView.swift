//
//  VideoView.swift
//  highpitch
//
//  Created by musung on 11/21/23.
//

import SwiftUI

import SwiftUI
import AVKit

struct VideoView: NSViewRepresentable {
    typealias NSViewType = NSView
    
    var videoURL: URL
    var avPlayer: AVPlayer
    
    func makeNSView(context: Context) -> NSView {
        let playerView = AVPlayerView()
        playerView.player = avPlayer
        playerView.controlsStyle = .none
        return playerView
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // Update code if needed
    }
}

//#Preview {
//    VideoView()
//}
