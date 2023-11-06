//
//  ChartUtils.swift
//  highpitch
//
//  Created by yuncoffee on 10/13/23.
//

import Foundation

extension Date {
    // MARK: Date.now()를 기준으로 YYYYMMDDHHMMSS.m4a 형식의 String으로 변환
    func makeM4aFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: Date())
    }
    
    // MARK: MediaManager밑에 있는 fileName을 통해서 createAt에 넣을 날짜 생성
    func m4aNameToCreateAt(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMddHHmmss"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            
            let formattedDate = outputFormatter.string(from: date)
            
            return formattedDate
        } else {
            return "Invalid Date"
        }
    }
    
    // MARK: createAt의 날짜를 통해서 연습 탭에 띄울 날짜 생성
    func createAtToPracticeDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "YYYY.MM.dd(E) HH:mm:ss"
            outputFormatter.locale = Locale(identifier: "ko_KR")
            
            let dateString = outputFormatter.string(from: date)
            
            return dateString
        } else {
            return "Invalid Date"
        }
    }
    
    // MARK: 용팔이
    func createAtToYMD(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "YYYY.MM.dd"
            
            let dateString = outputFormatter.string(from: date)
            
            return dateString
        } else {
            return "Invalid Date"
        }
    }
    
    // MARK: 용팔이
    func createAtToHMS(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        if let date = inputFormatter.date(from: input) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm:ss"
            
            let dateString = outputFormatter.string(from: date)
            
            return dateString
        } else {
            return "Invalid Date"
        }
    }
    
    static func diffNowToPractieDate(input: String) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        let currentDate = Date()
        guard let inputDate = dateFormatter.date(from: input) else { return "잘못된 날짜" }
        
        let diffs = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: inputDate,
            to: currentDate
        )
        
        if let year = diffs.year, year > 0 {
            result = "\(year)년 전"
        } else if let month = diffs.month, month > 0 {
            result = "\(month)달 전"
        } else if let day = diffs.day, day > 0 {
            result = "\(day)일 전"
        } else if let hour = diffs.hour, hour > 0 {
            result = "\(hour)시간 전"
        } else if let minute = diffs.minute, minute > 0 {
            result = "\(minute)분 전"
        } else if let second = diffs.second, second > 30 {
            result = "\(second)초 전"
        } else {
            result = "방금 전"
        }
        
        return result
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
