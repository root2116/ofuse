//
//  CapacitorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI



struct CapacitorView: View {
    
    
    @Environment(\.managedObjectContext) var managedObjContext
    

    @SectionedFetchRequest<String, Flow> var flowSections : SectionedFetchResults<String, Flow>
    
    var capacitor_id : UUID
    init(capacitor_id: UUID){
        self.capacitor_id = capacitor_id
        
        self._flowSections = SectionedFetchRequest<String,Flow>(
                                sectionIdentifier: \.dateText,
                                sortDescriptors: [SortDescriptor(\.date, order: .reverse)],
                                predicate: NSPredicate(format: "from_id == %@ || to_id == %@", capacitor_id as CVarArg, capacitor_id as CVarArg ),
                                animation: nil)
        
    }


    @State private var showingAddView = false
   
    
    
    
    
    

    
    
    var body: some View {
        
        
            VStack(alignment: .leading) {
//                Text("Balance: \(totalBalance()) yen")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
                List {
                    
                    ForEach(flowSections){ section in
                        Section(section.id) {
                            ForEach(section) { flowEntry in
                                FlowView(flow: flowEntry, capacitor_id: capacitor_id)
                            }.onDelete {
                                
                                self.deleteFlow(at: $0, in: section)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Flow", systemImage: "plus")
                    }
                }
//                ToolbarItem(placement: .navigationBarLeading){
//                    EditButton()
//                }
            }
            .sheet(isPresented: $showingAddView){
                AddFlowView(from: capacitor_id)
            }
            
            
        
    }
    private func deleteFlow(at offsets: IndexSet, in flow: SectionedFetchResults<String, Flow>.Element){
        
        
        withAnimation{
            offsets.map { flow[$0] }.forEach(managedObjContext.delete)

            DataController().save(context: managedObjContext)
        }
    }
//    private func totalBalance() -> Int {
//        var totalBalance = 0
//
//        for flowSection in flowSections {
//            for flowEntry in flowSection {
//                totalBalance += Int(flowEntry.amount)
//            }
//        }
//        return totalBalance
//    }
    

}


