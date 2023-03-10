//
//  ChargeView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI
import CoreData

struct ChargeView: View {
    @ObservedObject var charge: Charge
    
    var openedCapId : UUID
    var balance: Int
    @Environment(\.managedObjectContext) private var managedObjectContext

    
    var body: some View {
        
            NavigationLink(destination: EditChargeView(charge: charge)) {
                HStack {
                    VStack {
                        Text(getYearAndMonth(charge:charge))
                            .foregroundColor(.gray)
                            .font(.caption2)
                            .padding(.leading,5)
                        
                        Text(getDay(charge: charge))
                            .foregroundColor(.gray).font(.title3)
                            .padding(.leading,5)
                            .frame(width:30)
                            
                    }
                    
                    VStack(alignment: .leading, spacing: 2){
                        
                        HStack{
                            if charge.status == Status.confirmed.rawValue {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if charge.status == Status.upcoming.rawValue {
                                Image(systemName: "hourglass.circle.fill").foregroundColor(.orange)
                            } else { // if pending
                                if charge.included {
                                    Image(systemName:"link.circle.fill").foregroundColor(.cyan)
                                } else {
                                    Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                                }
                            }
                            Text(charge.name ?? "")
                                .bold()
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        HStack{
                            Text("Balance: ¥ \(balance)").foregroundColor(.gray).font(.callout)
                            if charge.category?.id != uncatId! {
                                HStack(spacing:5){
                                    Text(charge.category?.name ?? "")
                                            .padding(.all, 2)
                                            .font(.caption2)
                                            .background(Color.blue)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(3)

                                    

                                }
                            }
                        }
                            
                            
                            
                       
//                            if tagArray(charge.tags).count > 0 {
//                                HStack(spacing:5){
//
//
//                                    ForEach(tagArray(charge.tags).prefix(3)){ tag in
//
//                                            Text(tag.name!)
//                                                .padding(.all, 2)
//                                                .font(.caption2)
//                                                .background(Color.blue)
//                                                .foregroundColor(Color.white)
//                                                .cornerRadius(3)
//
//                                    }
//
//                                }
//                            }
                            
                        
                        
                        
                        
                        
                        
//                        if charge.from != nil {
//                            if charge.from!.type == CapType.bank.rawValue && charge.to!.id! == capacitor_id {
//                                Text("Bank: ¥ \(balance_of_the_related_bank(charge:charge, capacitor_id: capacitor_id))").foregroundColor(.gray).font(.footnote)
//                            }
//                        }
                        
                    }
                    
                    Spacer()
                    
                    VStack(spacing:2){
                        
                        
                        if let fromCap = charge.from, let toCap = charge.to {
                            
                            if toCap.id == gndId {
                                Text("¥ ") + Text("-\(Int(charge.amount))").foregroundColor(.red)
                            } else if fromCap.id == srcId {
                                Text("¥ ") + Text("+\(Int(charge.amount))").foregroundColor(.green)
                            } else if fromCap.id == openedCapId {
                                Text("¥ ") + Text("-\(Int(charge.amount))").foregroundColor(.orange)
                            } else {
                                Text("¥ ") + Text("\(Int(charge.amount))").foregroundColor(.orange)
                            }
                        }
                        
                        
                        if openedCapId == charge.from_id {
                            Text("\(charge.to?.name ?? "")").foregroundColor(.gray).font(.caption2)
                        } else {
                            Text("\(charge.from?.name ?? "")").foregroundColor(.gray).font(.caption2)
                        }
                    }
                    
                    
                    
                
                
                
                    
                   
                
                    
                }
            }
    }
    
    private func getDay(charge: FetchedResults<Charge>.Element) -> String{
        
        
        let format = DateFormatter()
        format.dateFormat = "d"
        return format.string(from: charge.date ?? Date())
    }
    
    private func getYearAndMonth(charge: FetchedResults<Charge>.Element) -> String {
        let format = DateFormatter()
        format.dateFormat = "yy.MM"
        return format.string(from: charge.date ?? Date())
    }
    
   
    
    
//    private func balance_of_the_related_bank(charge: Charge, capacitor_id: UUID) -> Int {
//
//        let capacitor = charge.from!
//
//        var balance = capacitor.init_balance
//        print("Capacitor Name: \(capacitor.name!)")
//        print("Init: \(capacitor.init_balance)")
//
//        let in_charges = chargeArray(capacitor.in_charges)
//        let out_charges = chargeArray(capacitor.out_charges)
//
//        for in_charge in in_charges {
//            if (in_charge.date! < charge.date!) || ( in_charge.date! == charge.date! && in_charge.createdAt! < charge.createdAt!) || in_charge.id == charge.id {
//                if in_charge.status != Status.pending.rawValue {
//
//                    print("Charge name: \(in_charge.name!), Amount: +\(in_charge.amount)")
//                    balance += in_charge.amount
//
//                }
//            }
//
//        }
//
//        for out_charge in out_charges {
//            if (out_charge.date! < charge.date!) || ( out_charge.date! == charge.date! && out_charge.createdAt! < charge.createdAt!) || out_charge.id == charge.id {
//                if out_charge.status != Status.pending.rawValue {
//
//                    print("Charge name: \(out_charge.name!), Amount: -\(out_charge.amount)")
//                    balance -= out_charge.amount
//
//                }
//            }
//        }
//
//        return Int(balance)
//    }
    
}

struct ChargeView_Previews: PreviewProvider {
    
    static let context = DataController().container.viewContext
    
    static var previews: some View {
        let charge = Charge.oneCharge(moc: ChargeView_Previews.context)
        ChargeView(charge: charge, openedCapId: UUID(), balance: 1000).environment(\.managedObjectContext, context)
    }
}

extension Charge {
    static func oneCharge(moc:NSManagedObjectContext) -> Charge {
        let charge = Charge(context: moc)
        charge.amount = 100
        charge.createdAt = Date()
        charge.name = "生写真がほしいな"
        charge.status = Int16(Status.confirmed.rawValue)
        charge.id = UUID()
        charge.from_id = gndId!
        charge.to_id = gndId!
        
        
        return charge
    }
}
