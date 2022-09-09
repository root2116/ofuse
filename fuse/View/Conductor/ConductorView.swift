//
//  ConductorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/18.
//

import SwiftUI

struct ConductorView: View {
    @ObservedObject var conductor : Conductor
    
    
    var body: some View {
        NavigationLink(destination:EditConductorView(conductor: conductor) ){
            HStack{
                
                VStack{
                    Text("Next").font(.footnote).foregroundColor(.green)
                    if withinThisYear(date: conductor.nextToPay ?? Date()) {
                        Text(formatDate(date:conductor.nextToPay ?? Date(), formatStr: "M.d"))
                    } else{
                        Text(formatDate(date:conductor.nextToPay ?? Date(), formatStr: "yyyy")).font(.caption2).foregroundColor(.gray)
                        Text(formatDate(date:conductor.nextToPay ?? Date(), formatStr: "M.d"))
                    }
                    
                    
                }.frame(width:46)
                
                VStack(alignment: .leading){
                   
                    Text(conductor.name ?? "").padding(EdgeInsets(
                        top: 5,
                        leading: 10,
                        bottom: 2,
                        trailing: 0
                    ))
                        
                    
                    HStack{
                        if conductor.from != nil && conductor.to != nil {
                            
                        
                        Text(conductor.from!.name!).font(.footnote).foregroundColor(.gray)
                        Image(systemName: "arrow.right").foregroundColor(.gray).font(.system(size: 12))
                        Text(conductor.to!.name!).font(.footnote).foregroundColor(.gray)
                            
                        }
                    }.padding(.leading,10)
                    
                }
                
                Spacer()
                
                
                Text("¥ \(conductor.amount)")
               
                
                
                
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

//struct ConductorView_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        let conductor  =
//
//        ConductorView(conductor: conductor)
//    }
//}
