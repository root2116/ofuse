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
                    Text(formatDate(date:conductor.next!))
                    
                }.frame(width:46)
                
                VStack(alignment: .leading){
                   
                    Text(conductor.name!).padding(EdgeInsets(
                        top: 5,
                        leading: 10,
                        bottom: 2,
                        trailing: 0
                    ))
                        
                    
                    HStack{
                        Text(conductor.from!.name!).font(.footnote).foregroundColor(.gray)
                        Image(systemName: "arrow.right").foregroundColor(.gray).font(.system(size: 12))
                        Text(conductor.to!.name!).font(.footnote).foregroundColor(.gray)
                    }.padding(.leading,10)
                    
                }
                
                Spacer()
                Text("¥ \(conductor.amount)")
               
                
                
                
            }
        }
    }
    
    private func formatDate(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "M.d"
        return format.string(from: date)
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
