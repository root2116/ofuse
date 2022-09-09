//
//  FlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI
import CoreData

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
                            if flow.status == Status.confirmed.rawValue {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if flow.status == Status.coming.rawValue {
                                Image(systemName: "hourglass.circle.fill").foregroundColor(.orange)
                            } else if flow.status == Status.pending.rawValue {
                                Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                            } else {
                                Image(systemName:"link.circle.fill").foregroundColor(.cyan)
                            }

                            Text(flow.name ?? "")
                                .bold()
                        }
                        
                        
                        Text("Balance: ¥ \(balance)").foregroundColor(.gray).font(.callout)
                        if flow.from != nil {
                            if flow.from!.type == CapType.bank.rawValue && flow.to!.id! == capacitor_id {
                                Text("Bank: ¥ \(balance_of_the_related_bank(flow:flow, capacitor_id: capacitor_id))").foregroundColor(.gray).font(.footnote)
                            }
                        }
                        
                    }
                    
                    Spacer()
                    if flow.from != nil {
                        
                        
                        if flow.to!.id! == outsideId {
                            Text("¥ ") + Text("-\(Int(flow.amount))").foregroundColor(.red)
                        } else if flow.from!.id! == outsideId {
                            Text("¥ ") + Text("+\(Int(flow.amount))").foregroundColor(.green)
                        } else if flow.from!.id! == capacitor_id {
                            Text("¥ ") + Text("-\(Int(flow.amount))").foregroundColor(.red)
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
    
    
    private func balance_of_the_related_bank(flow: Flow, capacitor_id: UUID) -> Int {
        
//        let fetchRequestCapacitor = NSFetchRequest<NSFetchRequestResult>()
//        fetchRequestCapacitor.entity = Capacitor.entity()
//        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", flow.from as CVarArg)
//        let capacitors = try? managedObjectContext.fetch(fetchRequestCapacitor) as? [Capacitor]
//
        
        let capacitor = flow.from!
        
        var balance = capacitor.init_balance
        print("Capacitor Name: \(capacitor.name!)")
        print("Init: \(capacitor.init_balance)")
        
        let in_flows = flowArray(capacitor.in_flows)
        let out_flows = flowArray(capacitor.out_flows)
        
        for in_flow in in_flows {
            if (in_flow.date! < flow.date!) || ( in_flow.date! == flow.date! && in_flow.createdAt! < flow.createdAt!) || in_flow.id == flow.id {
                if in_flow.status != Status.pending.rawValue {
                    
                    print("Flow name: \(in_flow.name!), Amount: +\(in_flow.amount)")
                    balance += in_flow.amount
                    
                }
            }
                
        }
        
        for out_flow in out_flows {
            if (out_flow.date! < flow.date!) || ( out_flow.date! == flow.date! && out_flow.createdAt! < flow.createdAt!) || out_flow.id == flow.id {
                if out_flow.status != Status.pending.rawValue {
                   
                    print("Flow name: \(out_flow.name!), Amount: -\(out_flow.amount)")
                    balance -= out_flow.amount
                    
                }
            }
        }
        
        return Int(balance)
    }
    
}

//struct FlowView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowView()
//    }
//}
