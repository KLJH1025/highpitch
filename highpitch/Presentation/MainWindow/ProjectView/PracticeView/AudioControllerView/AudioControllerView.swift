//
//  AudioControllerView.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

import SwiftUI

struct AudioControllerView: View {
    private var audioPlayer : AudioPlayable
    private var audioPath: URL
    @State var currentTime = 0.0
    @State var isPlaying = false
    @State var isDragging = false
    @State var prevState = false
    
    init(
        audioPlayer: AudioPlayable,
        audioPath: URL
    ) {
        self.audioPlayer = audioPlayer
        self.audioPath = audioPath
    }
    var body: some View {
        VStack(spacing: 0) {
            sliderContainer
            buttonContainer
        }
        .padding(.top, .HPSpacing.xxxsmall)
        .padding(.bottom, .HPSpacing.xsmall)
        .frame(maxWidth: .infinity, minHeight: 72)
        .background(Color.HPComponent.audioControllerBackground)
        .background(.ultraThinMaterial)
        .border(.HPComponent.stroke, width: 1, edges: [.top])
        .onAppear {
            settingAudio(filePath: audioPath)
        }.onChange(of: audioPlayer.currentTime) { oldValue , newValue in
            self.currentTime = newValue
            if newValue == 0 {
                
                audioPlayer.pausePlaying()
            }
        }.onChange(of: isDragging) { _, newValue in
            if newValue {
                audioPlayer.pausePlaying()
            } else {
                if prevState {
                    audioPlayer.play()
                }
            }
        }.onChange(of: audioPlayer.isPlaying) { _, newValue in
            isPlaying = newValue
        }.onDisappear {
            audioPlayer.stopPlaying()
        }
    }
}

extension AudioControllerView {
    /// 음성파일 URL을 MediaManager에 등록
    private func settingAudio(filePath: URL) {
        do {
            try audioPlayer.registerAudio(url: filePath)
        } catch {
            print(error.localizedDescription)
        }
    }
    private func play() {
        audioPlayer.play()
    }
    private func pause() {
        audioPlayer.pausePlaying()
    }
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}

// MARK: - Views
extension AudioControllerView {
    @ViewBuilder
    private var sliderContainer: some View {
        VStack(spacing: 0) {
            Slider(value: $currentTime, in: 0...audioPlayer.getDuration()) { edit in
                if edit {
                    isDragging = true
                    prevState = isPlaying
                } else {
                    isDragging = false
                    audioPlayer.setCurrentTime(time: currentTime)
                }
            }
            .tint(Color.HPPrimary.base)
            .padding(.horizontal, .HPSpacing.large)
            HStack(spacing: 0) {
                Text(timeString(time: currentTime))
                    .systemFont(.caption2)
                    .foregroundStyle(Color.HPTextStyle.light)
                Spacer()
                Text(timeString(time: audioPlayer.getDuration()))
                    .systemFont(.caption2)
                    .foregroundStyle(Color.HPTextStyle.light)
            }
            .padding(.horizontal, .HPSpacing.small)
            .offset(y: .HPSpacing.xxxsmall)
        }
    }
    
    @ViewBuilder
    private var buttonContainer: some View {
        HStack(spacing: .HPSpacing.small + .HPSpacing.xxxxsmall) {
            goBackward
            controllButton
            goForward
        }
    }
    
    @ViewBuilder
    private var controllButton: some View {
        Button {
            isPlaying ? pause() : play()
        } label: {
            Label(
                isPlaying
                ? "멈춤"
                : "재생",
                systemImage: isPlaying
                ? "pause.fill"
                : "play.fill"
            )
            .systemFont(.largeTitle)
            .labelStyle(.iconOnly)
            .foregroundStyle(Color.HPTextStyle.base)
            .imageScale(.large)
        }
        .frame(width: 24, height: 24)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var goForward: some View {
        Button {
            audioPlayer.playAfter(second: 10)
        } label: {
            Label("앞으로 10초",
                systemImage: "goforward.10"
            )
            .systemFont(.subTitle)
            .labelStyle(.iconOnly)
            .foregroundStyle(Color.HPTextStyle.base)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var goBackward: some View {
        Button {
            audioPlayer.playAfter(second: -10)
        } label: {
            Label("뒤로 10초",
                systemImage: "gobackward.10"
            )
            .systemFont(.subTitle)
            .labelStyle(.iconOnly)
            .foregroundStyle(Color.HPTextStyle.base)
        }
        .buttonStyle(.plain)
    }
}
// #Preview {
//    @State var practice = PracticeModel(practiceName: "", index: 0, isVisited: <#Bool#>, creatAt: "", utterances: [], summary: PracticeSummaryModel())
//    return AudioControllerView(practice: $practice)
//        .environment(MediaManager())
//        .environment(ProjectManager())
// }
