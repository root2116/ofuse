//
//  FlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI

struct FlowView: View {
    @ObservedObject var flow: Flow
    
    var capacitor_id : UUID
    var balance: Int
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.outsideId) var outsideId
    var body: some View {
        
            NavigationLink(destination: EditFlowView(flow: flow)) {
                HStack {
                    VStack {
                        Text(getYearAndMonth(flow:flow))
                            .foregroundColor(.gray)
                            .font(.caption2)
                            .padding(.leading,5)
                        
                        Text(getDay(flow: flow))
                            .foregroundColor(.gray).font(.title3)
                            .padding(.leading,5)
                            .frame(width:30)
                            
                    }
                    
                    VStack(alignment: .leading, spacing: 6){
                        
                        HStack{
                            if flow.status == Int16(Status.confirmed.rawValue) {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if flow.status == Int16(Status.pending.rawValue) {
                                Image(systemName: "hourglass.circle.fill").foregroundColor(.orange)
                            } else {
                                Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                            }

                            Text(flow.name ?? "")
                                .bold()
                        }
                        
                       
                        Text("Balance: ¥ \(balance)").foregroundColor(.gray).font(.callout)

                    }
                    
                    Spacer()
                    if flow.from != nil {
                        
                        
                        if capacitor_id == flow.from!.id! {
                            Text("¥ ") + Text("-\(Int(flow.amount))").foregroundColor(.red)
                        } else if flow.from!.id! == outsideId {
                            Text("¥ ") + Text("+\(Int(flow.amount))").foregroundColor(.green)
                        } else {
                            Text("¥ ") + Text("\(Int(flow.amount))").foregroundColor(.orange)
                        }
                        
                    }
                    
                }
            }
    }
    
    private func getDay(flow: FetchedResults<Flow>.Element) -> String{
        
        
        let format = DateFormatter()
        format.dateFormat = "d"
        return format.string(from: flow.date ?? Date())
    }
    
    private func getYearAndMonth(flow: FetchedResults<Flow>.Element) -> String {
        let format = DateFormatter()
        format.dateFormat = "yy.MM"
        return format.string(from: flow.date ?? Date())
    }
    
}

//struct FlowView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowView()
//    }
//}
