//
//  CurrentView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/18.
//

import SwiftUI

struct CurrentView: View {
    @ObservedObject var current : Current
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State private var nearest = Date()
    
    
    var body: some View {
        NavigationLink(destination:EditCurrentView(current: current) ){
            HStack{
                
                VStack{
                    Text("Next").font(.footnote).foregroundColor(.green)
                    Text(formatDate(date:nearest, formatStr: "M.d"))
                        .onAppear{
                            nearest = DataController().nearestUpcomingPayment(current: current, context: managedObjContext) ?? Date()
                        }
                    
                }.frame(width:46)
                
                VStack(alignment: .leading){
                   
                    Text(current.name ?? "").padding(EdgeInsets(
                        top: 5,
                        leading: 10,
                        bottom: 2,
                        trailing: 0
                    ))
                        
                    
                    HStack{
                        if let from = current.from, let to = current.to {
                            
                            Text(from.name ?? "").font(.footnote).foregroundColor(.gray)
                            Image(systemName: "arrow.right").foregroundColor(.gray).font(.system(size: 12))
                            Text(to.name ?? "").font(.footnote).foregroundColor(.gray)
                            
                        }
                    }.padding(.leading,10)
                    
                }
                
                Spacer()
                
                
                Text("¥ \(current.amount)")
               
                
                
                
            }
        }
        
        
    }
    
    

    
    private func withinThisYear(date: Date) -> Bool {
        let today = Date()
        
        let this_year = Calendar.current.component(.year, from: today)
        
        let year = Calendar.current.component(.year, from: date)
        
        if this_year == year {
            return true
        } else {
            return false
        }
    }
    
}

//struct CurrentView_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        let current  =
//
//        CurrentView(current: current)
//    }
//}
