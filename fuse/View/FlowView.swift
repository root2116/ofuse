//
//  FlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI

struct FlowView: View {
    var flow: Flow
    
    var capacitor_id : UUID
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var body: some View {
        
            NavigationLink(destination: EditFlowView(flow: flow)) {
                HStack {
                    Text(getDay(flow: flow))
                        .foregroundColor(.gray).font(.title3)
                        .padding(.leading,5)
                        .frame(width:30)
                        
                    VStack(alignment: .leading, spacing: 6){
                        
                        HStack{
                            if flow.status == Int16(Status.confirmed.rawValue) {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if flow.status == Int16(Status.pending.rawValue) {
                                Image(systemName: "arrow.clockwise.circle.fill").foregroundColor(.orange)
                            } else {
                                Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                            }

                            Text(flow.name!)
                                .bold()
                        }
                        
                        if capacitor_id == flow.from!.id! {
                            Text("¥ ") + Text("-\(Int(flow.amount))").foregroundColor(.red)
                        } else {
                            Text("¥ ") + Text("+\(Int(flow.amount))").foregroundColor(.green)
                        }
                        

                    }
                    Spacer()

                }
            }
    }
    
    private func getDay(flow: FetchedResults<Flow>.Element) -> String{
        print(flow)
        let dt = Date()
        let format = DateFormatter()
        format.dateFormat = "dd"
        return format.string(from: dt)
    }
    
}

//struct FlowView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowView()
//    }
//}
