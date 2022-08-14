//
//  CapacitorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI

struct ListItem: Identifiable {
    var id = UUID()
    
    let sectionName: String
    let items : [Flow]
}

struct CapacitorView: View {
    
    
//    @Environment(\.capacitorId) var capacitor_id
    @Environment(\.managedObjectContext) var managedObjContext
    
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var flow: FetchedResults<Flow>
    
//    @SectionedFetchRequest<String, Flow> private var flowSections: SectionedFetchResults<String, Flow>

//    @State private var from
    
    //これが変化したら再描画されるようにObservedObjectつけてる
    @ObservedObject var capacitor : FetchedResults<Capacitor>.Element
    @State private var showingAddView = false
   

    
    
    
    
//    init(capacitor:FetchedResults<Capacitor>.Element){

        


        
//        _flowSections = SectionedFetchRequest<String, Flow>(
//                        sectionIdentifier: \.dateText,
//                        sortDescriptors: [SortDescriptor(\.date, order: .reverse)],
//                        predicate: NSPredicate(format: " == %@", capacitor_id.uuidString)
//                    )

//    }

    
    
    var body: some View {
        
            
            VStack(alignment: .leading) {
//                Text("Balance: \(totalBalance()) yen")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
                List {
//                    ForEach(flowSections) { flowSection in
//                            Section(flowSection.id) {
//                                ForEach(flowSection,id: \.id) { flowEntry in
//                                    FlowView(flow:flowEntry)
//
//                                }.onDelete{
//                                    self.deleteFlow(at: $0, in: flowSection)
//
//                                }
//                            }
//                        }
                    
                    ForEach(group_and_sort(capacitor: capacitor), id: \.id ){ section in
                        Section(header: Text(section.sectionName)) {
                            ForEach(section.items, id:\.id) { flowEntry in
                                FlowView(flow: flowEntry, capacitor: capacitor)
                            }.onDelete {
                                self.deleteFlow(at: $0, in: section)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
            }
            .navigationTitle(capacitor.name!)
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
                AddFlowView(from: capacitor.id!)
            }
            
            
        
    }
    private func deleteFlow(at offsets: IndexSet, in flow: ListItem){
        
        
        withAnimation{
            offsets.map { flow.items[$0] }.forEach(managedObjContext.delete)

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
    
    private func group_and_sort(capacitor:FetchedResults<Capacitor>.Element ) -> [ListItem] {
        
        let in_flows = capacitor.in_flows as? Set<Flow> ?? []
        let out_flows = capacitor.out_flows as? Set<Flow> ?? []
        let merge = in_flows.union(out_flows)
        let sorted_merge = merge.sorted {
            $0.dateText < $1.dateText
        }
      
        
        let grouped = Dictionary(grouping: sorted_merge){ flow in flow.dateText}
        
        
        
        
        return Dict2ListItem(dict: grouped)
    }
    
    private func flowArray(_ flows: NSSet?) -> [Flow] {
            let set = flows as? Set<Flow> ?? []
            return set.sorted {
                $0.dateText < $1.dateText
            }
    }
    
    private func Dict2ListItem(dict: Dictionary<String,[Flow]>) -> [ListItem]{
        let keys = Array(dict.keys).sorted(by: >)
        
        return keys.map { ListItem(sectionName: $0,items: dict[$0]!) }
    }
    
    
   
    

}

//struct CapacitorView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        CapacitorView()
//    }
//}
