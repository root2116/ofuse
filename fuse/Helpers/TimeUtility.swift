//
//  TimeFormatting.swift
//  fuse
//
//  Created by araragi943 on 2022/08/11.
//

infix operator %%
func %%(lhs: Int, rhs: Int) -> Int{
    return ((lhs % rhs) + rhs) % rhs
}


import Foundation

func calcTimeSince(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    
    if minutes < 120 {
        return "\(minutes) minutes ago"
    } else if minutes >= 120 && hours < 48 {
        return "\(hours) hours ago"
    } else {
        return "\(days) days ago"
    }
}

func theLastDayOfTheMonth(month: Int) -> Int {
    
    
    let year = Calendar.current.component(.year,from: Date())
    
    
    let nextMonth = Calendar.current.date(from: DateComponents(year: year, month:month+1, day: 1, hour: 0, minute:0,second:0))
    let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: nextMonth! )
    
    return Calendar.current.component(.day, from: lastDay!)
}


// on_month: 0がJan,11がDec,  on_weekday: 0がSun, 6がSat, on_day: 0と31がlast,その他はそのまま対応
func tempNext(every: Int, span: String, on_day: Int, on_month: Int, on_weekday: Int) -> Date {
    let today = Date()
    let year = Calendar.current.component(.year, from:today)
    let month = Calendar.current.component(.month, from:today)
    let day = Calendar.current.component(.day, from:today)
    
    let calendar = Calendar(identifier: .gregorian)
    
    
    
    if span == "day" {
        return today
    } else if span == "week" {
        
        let today_weekday = Calendar.current.component(.weekday, from: today) - 1
        let nearest = Calendar.current.date(byAdding: .day, value: (on_weekday - today_weekday) %% 7, to: today)!
        return nearest
        
    } else if span == "month" {
        var on_day = on_day
        if on_day == 0 || on_day == 31 {
            on_day = theLastDayOfTheMonth(month: month)
        }
        
        if on_day >= day {
            
            return calendar.date(from: DateComponents(year: year, month: month, day: on_day , hour: 0, minute: 0, second: 0))!
        } else {
            return calendar.date(from: DateComponents(year: year, month: month + 1, day: on_day , hour: 0, minute: 0, second: 0))!
        }
    } else  {
        
        var on_day = on_day
        
        if on_day == 0 || on_day == 31 {
            on_day = theLastDayOfTheMonth(month: on_month+1)
        }
        
        if on_month >= month {
            return calendar.date(from: DateComponents(year: year, month: on_month + 1, day: on_day , hour: 0, minute: 0, second: 0))!
        } else {
            return calendar.date(from: DateComponents(year: year + 1, month: on_month + 1, day: on_day , hour: 0, minute: 0, second: 0))!
        }
    }
}


func formatDate(date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "M/d/yyyy"
    return format.string(from: date)
}


func calcNext(previous: Date, every: Int, span: String, on_day: Int, on_month: Int, on_weekday: Int) -> Date {
    
    let prev_year = Calendar.current.component(.year, from:previous)
    let prev_month = Calendar.current.component(.month, from:previous)
    let prev_weekday = Calendar.current.component(.weekday, from:previous)
    
    
    if span == "day" {
        return Calendar.current.date(byAdding:.day, value:every, to:previous)!
    } else if span == "week" {
        if prev_weekday < on_weekday {
            return Calendar.current.date(byAdding:.day,value:7*every + (on_weekday - prev_weekday) ,to: previous)!
        } else {
            return Calendar.current.date(byAdding:.day,value:7*every - (prev_weekday - on_weekday) ,to: previous)!
        }
    } else if span == "month" {
        return Calendar.current.date(from: DateComponents(year:prev_year,month: prev_month+every, day: on_day))!
    } else {
        return Calendar.current.date(from: DateComponents(year:prev_year + every,month: on_month, day: on_day))!
    }
}
