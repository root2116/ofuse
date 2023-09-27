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
        
        
        
        
        if on_month == month {
            if on_day >= day {
                return calendar.date(from: DateComponents(year: year, month: on_month, day: on_day , hour: 0, minute: 0, second: 0))!
            } else{
                return calendar.date(from: DateComponents(year: year + 1, month: on_month, day: on_day , hour: 0, minute: 0, second: 0))!
            }
        } else if on_month < month {
            return calendar.date(from: DateComponents(year: year + 1, month: on_month, day: on_day , hour: 0, minute: 0, second: 0))!
        } else {
            return calendar.date(from: DateComponents(year: year, month: on_month, day: on_day , hour: 0, minute: 0, second: 0))!
        }
        
    }
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
        print("Every year!!")
        return Calendar.current.date(from: DateComponents(year:prev_year + every,month: on_month, day: on_day))!
    }
}


func lastDay(year:Int, month: Int) -> Int {
    let calendar = Calendar(identifier: .gregorian)
    let firstDay = calendar.date(from: DateComponents(year: year, month: month))!
    
    let add = DateComponents(month:1, day: -1)
    let lastDay = calendar.date(byAdding: add, to: firstDay)!
    
    
    return Calendar.current.component(.day, from: lastDay)
    
    
}


func formatDate(date: Date, formatStr: String) -> String {
    let format = DateFormatter()
    format.dateFormat = formatStr
    return format.string(from: date)
}





func nearestCharge(current: Current) -> Charge? {
    let charges = chargeArray(current.charges)
    
    let today = Date()
    var old : Charge?
    
    for charge in charges {
        old = charge
        
        if charge.date! > today {
            return old!
        }
    }
    
    return nil
}

func nearestUpcomingCharge(current: Current) -> Charge? {
    let charges = chargeArray(current.charges)
    
    
    for charge in charges {
        if charge.status == Status.upcoming.rawValue {
            return charge
        }
    }
    
    return nil
}

//func nearestPayment(current: Current) -> Date {
//    let nearest = nearestCharge(current: current)
//
//
//    return nearest!.date!
//
//
//}

func nearestUpcomingPayment(current: Current) -> Date {
    let nearest = nearestUpcomingCharge(current: current)
    
    if nearest != nil {
        return nearest!.date!
    } else{
        // まだCapacitor内に実体としてなかったら
//        return current.nextToConduct!
        return Date()
    }
}



func isFutureDate(_ date: Date) -> Bool {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let otherDate = calendar.startOfDay(for: date)
    return today < otherDate
}


func lastDayOfMonth(for date: Date) -> Date? {
    let calendar = Calendar.current
    let components = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date))
    if let date = calendar.date(from: components), let range = calendar.range(of: .day, in: .month, for: date) {
        let lastDay = range.upperBound - 1
        let lastDayComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: lastDay)
        return calendar.date(from: lastDayComponents)
    }
    return nil
}

func nearestPayment(every: Int, span: String, on_day: Int, on_month: Int, on_weekday: Int) -> Date {
    let today = Date()
    
   
    if span == "week" {
        
        let weekday = Calendar.current.component(.weekday, from: today) - 1
        let offset = (Int(on_weekday) - weekday) %% 7
        return Calendar.current.date(byAdding: .day, value: offset, to: today)!
        
    } else if span == "month" {
        
        if on_day == 0 || on_day == 31 {
            if let lastDay = lastDayOfMonth(for: today) {
                return lastDay
            } else {
                print("lastDayOfMonth returned nil")
                return Date()
            }
        } else {
            
            return Calendar.current.date(bySetting: .day, value: Int(on_day), of: today)!
        }
        
        
    } else if span == "year" {
 
        let newNext = Calendar.current.date(bySetting: .month, value: Int(on_month), of: today)!
        
        if on_day == 0 || on_day == 31 {
            if let lastDay = lastDayOfMonth(for: newNext){
                return lastDay
            } else {
                print("lastDayOfMonth returned nil")
                return Date()
            }
        } else {
            return Calendar.current.date(bySetting: .day, value: Int(on_day), of: newNext)!
        }
    } else {
        return today
    }
    
}


func getDailyRange() -> (start: Date, end: Date) {
    let start = Calendar.current.startOfDay(for: Date())
    let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
    return (start, end)
}

func getWeeklyRange() -> (start: Date, end: Date) {
    let start = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    let end = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: start)!
    return (start, end)
}

func getMonthlyRange() -> (start: Date, end: Date) {
    let start = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
    let end = Calendar.current.date(byAdding: .month, value: 1, to: start)!
    return (start, end)
}


func getYearlyRange() -> (start: Date, end: Date) {
    let calendar = Calendar.current
    let start = calendar.date(from: calendar.dateComponents([.year], from: Date()))!
    let end = calendar.date(byAdding: .year, value: 1, to: start)!
    return (start, end.addingTimeInterval(-1)) // endは次の年の最初の日なので、1秒減算して今年の最後の日を取得
}
