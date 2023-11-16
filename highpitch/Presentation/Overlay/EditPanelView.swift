//
//  EditPanelView.swift
//  highpitch
//
//  Created by 이재혁 on 11/13/23.
//

import SwiftUI

struct EditPanelView: View {
    var floatingPanelController: PanelController
    
    @State private var fillerWordPanelOn = true
    @State private var speedPanelOn = true
    @State private var timerPanelOn = true

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(spacing: 0) {
                    Text("실시간 피드백 받을 항목을 선택 및 이동해서")
                        .systemFont(.caption,weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.dark)
                    Text("레이아웃을 편집해보세요.")
                        .systemFont(.caption,weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.dark)
                }
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Toggle(isOn: $fillerWordPanelOn) {
                        Text("습관어")
                            .systemFont(.caption,weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.dark)
                            .onChange(of: fillerWordPanelOn) { _, value in
                                if value {
                                    SystemManager.shared.instantFeedbackManager.activePanels.insert(InstantPanel.fillerWord)
                                } else {
                                    SystemManager.shared.instantFeedbackManager.activePanels.remove(InstantPanel.fillerWord)
                                }
                            }
                    }
                    .toggleStyle(PurpleCheckboxStyle())
                    
                    Toggle(isOn: $speedPanelOn) {
                        Text("말 빠르기")
                            .systemFont(.caption,weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.dark)
                            .onChange(of: speedPanelOn) { _, value in
                                if value {
                                    SystemManager.shared.instantFeedbackManager.activePanels.insert(InstantPanel.speed)
                                } else {
                                    SystemManager.shared.instantFeedbackManager.activePanels.remove(InstantPanel.speed)
                                }
                            }
                    }
                    .toggleStyle(PurpleCheckboxStyle())
                }
                VStack(alignment: .leading) {
                    Toggle(isOn: $timerPanelOn) {
                        Text("타이머")
                            .systemFont(.caption,weight: .semibold)
                            .foregroundStyle(Color.HPTextStyle.dark)
                            .onChange(of: timerPanelOn) { _, value in
                                if value {
                                    SystemManager.shared.instantFeedbackManager.activePanels.insert(InstantPanel.timer)
                                } else {
                                    SystemManager.shared.instantFeedbackManager.activePanels.remove(InstantPanel.timer)
                                }
                            }
                    }
                    .toggleStyle(PurpleCheckboxStyle())
                    
                }
            }
        
            Spacer()
            
            HStack {
                Button(action: {
                    // activePanel에 모두 다 넣고
                    SystemManager.shared.instantFeedbackManager.activePanels.insert(InstantPanel.timer)
                    SystemManager.shared.instantFeedbackManager.activePanels.insert(InstantPanel.speed)
                    SystemManager.shared.instantFeedbackManager.activePanels.insert(InstantPanel.fillerWord)
                    
                    // 위치 기본값으로 조절
                    SystemManager.shared.instantFeedbackManager.feedbackPanelControllers[InstantPanel.timer]?.panel?
                        .setFrameOrigin(NSPoint(x:Int((NSScreen.main?.visibleFrame.width)! / 2) - 73, y:Int((NSScreen.main?.visibleFrame.height)!) - 15))
                    SystemManager.shared.instantFeedbackManager.feedbackPanelControllers[InstantPanel.speed]?.panel?
                        .setFrameOrigin(NSPoint(x:Int((NSScreen.main?.visibleFrame.width)!) - 178, y:276))
                    SystemManager.shared.instantFeedbackManager.feedbackPanelControllers[InstantPanel.fillerWord]?.panel?
                        .setFrameOrigin(NSPoint(x:Int((NSScreen.main?.visibleFrame.width)!) - 178, y:129))
                    SystemManager.shared.instantFeedbackManager.feedbackPanelControllers[InstantPanel.detailSetting]?.panel?
                        .setFrameOrigin(NSPoint(x:56, y:116))
                    
                    // UserDefaults도 원상복귀
                    UserDefaults.standard.set( String(Int((NSScreen.main?.visibleFrame.width)! / 2) - 73), forKey: "TimerPanelX")
                    UserDefaults.standard.set(String(Int((NSScreen.main?.visibleFrame.height)!) - 15), forKey: "TimerPanelY")
                    UserDefaults.standard.set( String(Int((NSScreen.main?.visibleFrame.width)!) - 178), forKey: "SpeedPanelX")
                    UserDefaults.standard.set(String(276), forKey: "SpeedPanelY")
                    UserDefaults.standard.set( String(Int((NSScreen.main?.visibleFrame.width)!) - 178), forKey: "FillerWordPanelX")
                    UserDefaults.standard.set(String(129), forKey: "FillerWordPanelY")
                    UserDefaults.standard.set(String(56), forKey: "DetailPanelX")
                    UserDefaults.standard.set(String(116), forKey: "DetailPanelY")

                }) {
                    Text("기본 레이아웃 사용")
                        .systemFont(.caption,weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.dark)
                }
                
                Spacer()
                
                Button(action: {
                    SystemManager.shared.instantFeedbackManager.isDetailSettingActive = false
                }) {
                    Text("확인")
                        .systemFont(.caption,weight: .semibold)
                        .foregroundStyle(Color.HPTextStyle.dark)
                }
            }
        }
        .frame(width: 436, height: 252)
        .background(Color.white)
        .onTapGesture {
            SystemManager.shared.instantFeedbackManager.focusedPanel = .detailSetting
        }
        .onHover { value in
            if !value {
                // Hover Out 되었을때, 해당 위치를 UserDefaults에 넣는다.
                UserDefaults.standard.set( String(Int(floatingPanelController.getPanelPosition()!.x)), forKey: "DetailPanelX")
                UserDefaults.standard.set(String(Int(floatingPanelController.getPanelPosition()!.y)), forKey: "DetailPanelY")
            }
        }
    }
}

struct PurpleCheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(Color.HPPrimary.base)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
        .padding()
    }
}
