//
//  UsageTopTierChart.swift
//  highpitch
//
//  Created by yuncoffee on 10/14/23.
//

/**
 버블 차트 + 사용한 필러단어 상세보기
 */
import SwiftUI
import Charts

struct UsageTopTierChart: View {
    var summary: PracticeSummaryModel
    @State
    var data: [FillerCountData] = []
    @State
    var fillerOffset: [FillerCountOffset] = []
    @State
    var fillerTypeCount = 0

    var body: some View {
        let maxHeight: CGFloat = 500
        VStack(alignment:.leading, spacing: 0) {
            header
            GeometryReader { geometry in
                let breakPoint: (chartSize: CGFloat, offset: CGFloat) =
                if geometry.size.width < 500 {
                    (chartSize: maxHeight * 0.5, offset: geometry.size.height * 0.37)
                } else {
                    (chartSize: maxHeight * 0.6, offset: geometry.size.height * 0.45)
                }
                
                ZStack {
                    if (summary.fillerWordCount > 0) {
                        VStack(spacing: 0) {
                            Text("\(fillerTypeCount)가지")
                                .systemFont(.title)
                                .foregroundStyle(Color.HPPrimary.base)
                            Text("습관어")
                                .systemFont(.footnote)
                                .foregroundStyle(Color.HPTextStyle.base)
                        }
                    } else {
                        Text("사용된 습관어가\n없어요!")
                            .multilineTextAlignment(.center)
                            .systemFont(.footnote)
                            .foregroundStyle(Color.HPTextStyle.base)
                    }
                    Chart(Array(data.enumerated()), id: \.1.id) { _, each in
                        if let color = each.color {
                            SectorMark(
                                angle: .value("count", each.value),
                                innerRadius: .ratio(0.618),
                                outerRadius: .ratio(0.8)
                            )
                            .foregroundStyle(color)
                        }
                    }
                    .scaledToFit()
                    .frame(
                        maxWidth: breakPoint.chartSize,
                        maxHeight: breakPoint.chartSize,
                        alignment: .center
                    )
                    /// annotation을 설정합니다.
                    ForEach(fillerOffset) {each in
                        VStack(alignment: .center, spacing: 0) {
                            Text("\(each.word)")
                                .systemFont(.title)
                                .foregroundStyle(Color.HPTextStyle.dark)
                            Text("\(each.value)회")
                                .systemFont(.footnote)
                                .foregroundStyle(Color.HPTextStyle.dark)
                            
                        }
                        .offset(CGSize(width: each.offset.width, height: each.offset.height))
                    }
                }
                .onChange(of: breakPoint.offset, { _, newValue in
                    self.fillerOffset = fillerWordOffset(size: newValue)
                })
                .onAppear {
                    self.fillerOffset = fillerWordOffset(size: breakPoint.offset)
                    self.fillerTypeCount = getFillerTypeCount()
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: geometry.size.height,
                    alignment: .center
                )
            }
            
        }
        .onAppear {
            self.data = getFillerCount()
        }
        .padding(.bottom, .HPSpacing.medium)
        .padding(.trailing, .HPSpacing.large + .HPSpacing.xxxxsmall)
        .frame(
            maxWidth: .infinity,
            minHeight: maxHeight,
            maxHeight: maxHeight,
            alignment: .topLeading
        )
    }
}

extension UsageTopTierChart {
    @ViewBuilder
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("습관어 종류 및 횟수")
                .systemFont(.subTitle)
                .foregroundStyle(Color.HPTextStyle.darker)
            Text("이번 연습에서 자주 언급된 습관어에요.")
                .systemFont(.body)
                .foregroundStyle(Color.HPTextStyle.dark)
        }
        .padding(.bottom, .HPSpacing.xsmall)
    }
}

/// 각 습관어의 사용 횟수를 기록하기 위한 구조체입니다.
struct FillerCountData: Identifiable {
    var id = UUID()
    var index: Int
    var value: Int
    var word: String
    var color: Color?
}

/// donut chart의 annotation offset을 설정하기 위한 구조체입니다.
struct FillerCountOffset: Identifiable {
    var id = UUID()
    var index: Int
    var value: Int
    var word: String
    var offset: CGSize
}

extension UsageTopTierChart {
    
    /// 습관어 사용 횟수를 '순서대로' 반환합니다.
    func getFillerCount() -> [FillerCountData] {
        if summary.fillerWordCount == 0 {
            return [FillerCountData(
                index: 0,
                value: 1,
                word: "",
                color: Color.HPPrimary.lightness
            )]
        }
        
        let eachFillerCount = summary.eachFillerWordCount
            .sorted(by: { $0.count > $1.count })
        var returnFillerCount: [FillerCountData] = []
        var index = -1, temp = 0
        for fillerWord in eachFillerCount {
            if (index != 4) { index += 1 }
            if (index == 4) {
                temp += fillerWord.count
            } else {
                returnFillerCount.append(FillerCountData(
                    index: index,
                    value: fillerWord.count,
                    word: fillerWord.fillerWord
                ))
            }
        }
        if (index == 4) {
            returnFillerCount.append(FillerCountData(
                index: index,
                value: temp,
                word: "기타"
            ))
        }
        for rightIndex in 0..<returnFillerCount.count {
            if rightIndex == 0 {
                returnFillerCount[rightIndex].color = Color.HPPrimary.base
            } else if rightIndex == 1 {
                returnFillerCount[rightIndex].color = Color.HPPrimary.light
            } else if rightIndex == 2 {
                returnFillerCount[rightIndex].color = Color.HPPrimary.lighter
            } else if rightIndex == 3 {
                returnFillerCount[rightIndex].color = Color.HPPrimary.lightness
            } else {
                returnFillerCount[rightIndex].color = Color.HPPrimary.lightnest
            }
        }
        return returnFillerCount
    }
    
    /// 사용된 습관어의 종류 수를 반환합니다.
    func getFillerTypeCount() -> Int {
        var fillerTypeCnt = 0
        let eachFillerCount = summary.eachFillerWordCount
        for fillerWord in eachFillerCount where fillerWord.count > 0 {
            fillerTypeCnt += 1
        }
        return fillerTypeCnt
    }
    
    /// annotation의 offset을 반환합니다.
    func fillerWordOffset(size: CGFloat) -> [FillerCountOffset] {
        if summary.fillerWordCount == 0 {
            return []
        }
        
        let fillerCnt = getFillerCount()
        var sumValue = 0
        for index in fillerCnt { sumValue += index.value }
        var radiusContainer: [Double] = []
        
        for index in fillerCnt where index.value > 0 {
            radiusContainer.append(Double(index.value) * 2.0 * CGFloat.pi / Double(sumValue))
        }
        var returnContainer: [FillerCountOffset] = []
        var temp = 0.0
        for index in 0..<radiusContainer.count {
            returnContainer.append(
                FillerCountOffset(
                    index: fillerCnt[index].index, value: fillerCnt[index].value,
                    word: fillerCnt[index].word,
                    offset:
                        CGSize(
                            width: Double(size) * cos((temp + radiusContainer[index] / 2) - CGFloat.pi / 2),
                            height:
                                Double(size) * sin((temp + radiusContainer[index] / 2) - CGFloat.pi / 2)))
                        )
            temp += radiusContainer[index]
        }
        return returnContainer
    }
}
