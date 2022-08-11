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
    
//    struct FlowData: Hashable, Identifiable {
//        var id = UUID()
//        var name : String
//        var date : Date
//        var amount : Int32
//        var status : Int16
//
//    }
//    struct MonthFlows : Identifiable {
//        var id = UUID()
//        var month : Int16
//        var header: String
//        var flowData: [FlowData]
//    }
//
    
    @Environment(\.managedObjectContext) var managedObjContext
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var flow: FetchedResults<Flow>
    @SectionedFetchRequest<String, Flow>(
            sectionIdentifier: \.dateText,
            sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
        ) private var flowSections: SectionedFetchResults<String, Flow>
    
    @State private var showingAddView = false
    
   
    
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Balance: \(totalBalance()) yen")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(flowSections) { flowSection in
                            Section(flowSection.id) {
                                ForEach(flowSection) { flowEntry in
                                    NavigationLink(destination: EditFlowView(flow: flowEntry)) {
                                        HStack {
                                            Text(getDay(date: flowEntry.date!))
                                                .foregroundColor(.gray).font(.title3)
                                                .padding(.leading,5)
                                                .frame(width:30)
                                                
                                            VStack(alignment: .leading, spacing: 6){
                                                
                                                HStack{
                                                    if flowEntry.status == Int16(Status.confirmed.rawValue) {
                                                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                                    } else if flowEntry.status == Int16(Status.pending.rawValue) {
                                                        Image(systemName: "arrow.clockwise.circle.fill").foregroundColor(.orange)
                                                    } else {
                                                        Image(systemName: "questionmark.circle.fill").foregroundColor(.gray)
                                                    }
            
                                                    Text(flowEntry.name!)
                                                        .bold()
                                                }
            
                                                Text("\(Int(flowEntry.amount))") + Text(" yen").foregroundColor(.red)
            
                                            }
                                            Spacer()
            
                                        }
                                    }
                                }.onDelete{
                                    self.deleteFlow(at: $0, in: flowSection)
                                    
                                }
                            }
                        }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Fuse")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Flow", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView){
                AddFlowView()
            }
        }
        .navigationViewStyle(.stack)
    }
    private func deleteFlow(at offsets: IndexSet, in flow: SectionedFetchResults<String,Flow>.Element){
        withAnimation{
            offsets.map { flow[$0] }.forEach(managedObjContext.delete)

            DataController().save(context: managedObjContext)
        }
    }
    private func totalBalance() -> Int {
        var totalBalance = 0

        for flowSection in flowSections {
            for flowEntry in flowSection {
                totalBalance += Int(flowEntry.amount)
            }
        }
        return totalBalance
    }
    
    private func getDay(date dt : Date) -> String{
        let format = DateFormatter()
        format.dateFormat = "dd"
        return format.string(from: dt)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


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
