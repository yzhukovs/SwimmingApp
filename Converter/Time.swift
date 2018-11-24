//
//  Time.swift
//  Converter
//
//  Created by Yvette Zhukovsky on 11/22/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import Foundation

struct Time {
    let stroke: Stroke
    let distance: Distance
    let course: Course
    let time: Double
}


func converterSCYLCM(time: Double, distance: Distance, stroke: Stroke) -> Double? {
    
    if distance == ._50 { return (time * 1.11) - (-stroke.factor!)    }
    if distance == ._100 { return (time * 1.11) - (-2 * stroke.factor!) }
    if distance == ._200 { return (time * 1.11) - (-4 * stroke.factor!) }
    if distance == ._400 || distance == ._800 { return (time * 0.8925)}
    if distance == ._1500 { return (time * 1.02)}
    return nil
}

func converterLCMSCY(time: Double, distance: Distance, stroke: Stroke) -> Double? {

    if distance == ._50 {return (time - stroke.factor!)/1.11 }
    if distance == ._100 {return (time - (2 * stroke.factor!) / 1.11)}
    if distance == ._200 {return (time - (4 * stroke.factor!) / 1.11) }
    if distance == ._400 || distance == ._800 { return (time / 0.8925)}
    if distance == ._1500 { return (time / 1.02)  }
    return nil
}




enum Stroke: String {
    case Backstroke
    case Butterfly
    case Breaststroke
    case Freestyle
    case IM
    
    var factor: Double? {
        switch self {
        case .Backstroke: return 0.6
        case .Breaststroke: return 1.0
        case . Butterfly: return 0.7
        case .IM: return 0.8
        case  .Freestyle: return 0.8
        default: return nil
        }
    }
    
    
    static let All = [Stroke.Backstroke, Stroke.Butterfly, Stroke.Breaststroke, Stroke.Freestyle, Stroke.IM]
    
    static func fromString(s: String) -> Stroke? {
        
        for stroke in Stroke.All {
            if s == stroke.rawValue { return stroke }
        }
        return nil
        
        
    }
}

enum Distance: Int {
  
    case _50 = 50
    case _100 = 100
    case _200 = 200
    case _400 = 400
    case _800 = 800
    case _1500 = 1500
    
    static let All = [ Distance._50, Distance._100, Distance._200, Distance._400, Distance._800, Distance._1500]
    
    static func fromString(n: String) -> Distance?{
        for distance in Distance.All {
            if n == distance.asString() { return distance }
            
        }
        return nil
    }
    
    
    
    
    func asString() -> String {
        return self.rawValue.description
    }
}

enum Course: String {
    case SCY
    case LCM
    
    static let All = [Course.SCY, Course.LCM]
    
    
    static func fromString(s: String) -> Course? {
        
        for course in Course.All {
            if s == course.rawValue { return course}
        }
        return nil
    }
    
    
    func converter() -> Converter {
        if self == .LCM { return converterSCYLCM }
        return converterLCMSCY
    }
    
}

typealias Converter = (Double, Distance, Stroke) -> Double?




func parseTime(enteredTime: String)-> Double? {

  let parts = enteredTime.components(separatedBy: ":")
    if parts.count == 1 {
     return Double(enteredTime)
    
    } else {
   let minutes = Int(parts.first ?? "") ?? 0
    let rest = Double(enteredTime.components(separatedBy: ":")[1]) ?? 0.0
    return (Double((minutes * 60)) + rest)
    }
}


func formatTime(time:Double)-> String {
   
    
    let minutes = Int(time) / 60
    let seconds = Double(Int(time) % 60) + time - Double(Int(time))
   
   return "\(minutes):\(NSString(format: "%2.3f", seconds))"
    
    
    
    
        
    }
    
    
    

// 1:23.456  -> 83.456
// 1:23      -> 83.0
// 12.345    -> 12.345
// 23        -> 23.0

