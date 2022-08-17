//
//  ContentView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI
import CoreData


enum Status: Int {
    case confirmed = 0
    case pending = 1
    case uncertain = 2
}



struct ContentView: View {
    
    
    
    
    var body: some View {
            TabView{
                CapacitorsView() //1枚目の子ビュー
                    .tabItem {
                        Image(systemName: "macpro.gen2.fill")
                        Text("Capacitors")
                    }
                ConductorsView() //2枚目の子ビュー
                    .tabItem {
                        Image(systemName: "arrow.triangle.pull")
                        Text("Conductors")
                    }
            }
        }
    
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


extension Flow {
    @objc
    var dateText: String {
        guard let date = self.date else {
            return "Unknown"
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM"
        return format.string(from: date)
    }
}

extension String {
    func size(with font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font : font]
        return (self as NSString).size(withAttributes: attributes)
    }
}


