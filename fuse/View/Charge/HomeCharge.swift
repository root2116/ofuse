
//
//  ChargeView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI
import CoreData

struct HomeChargeView: View {
    @ObservedObject var charge: Charge
    @Binding var isButtonVisible: Bool
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    
    
    var body: some View {
        
        NavigationLink(destination: EditChargeView(charge: charge, isButtonVisible: $isButtonVisible)) {
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
                            if charge.from_id == srcId {
                                Text("\(charge.to?.name ?? "")").foregroundColor(.gray).font(.caption2)
                            } else {
                                Text("\(charge.from?.name ?? "")").foregroundColor(.gray).font(.caption2)
                            }
                            
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
                        
                    }
                    
                    Spacer()
                    
                    VStack(spacing:2){
                        
                        
                        if let toCap = charge.to {
                            
                            if toCap.id == gndId {
                                Text("¥ ") + Text("-\(Int(charge.amount))").foregroundColor(.red)
                            } else {
                                Text("¥ ") + Text("+\(Int(charge.amount))").foregroundColor(.green)
                            }
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
    
   
    
    
    
}
