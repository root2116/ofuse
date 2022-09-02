//
//  CapacitorsView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI
struct CapacitorItem: Identifiable {
    var id = UUID()
    
    let name: String
    let entity: [SectionItem]
}
struct SectionItem: Identifiable,Hashable {
    var id = UUID()
    
    let sectionName: String
    var items : [Flow]
}



struct CapacitorsView: View {
    @Environment(\.managedObjectContext) var managedObjContext
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @State private var showingAddView = false
    
    @SectionedFetchRequest<String,Capacitor>(
                            sectionIdentifier: \.typeText,
                            sortDescriptors: [
                                SortDescriptor(\.type, order:.reverse),
                                SortDescriptor(\.createdAt, order: .reverse)
                            ]
                           )  private var capacitors

    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
//                Text("Balance: \(totalBalance()) yen")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
                List {
                    
                    ForEach(capacitors) { section in
                        Section(section.id) {
                            ForEach(section) { capacitor in
                                if capacitor.id! != UUID(uuidString: "CE130F1C-3B2F-42CA-8339-1549531E0102") {
                                    
                                
                                    
                                    
                                    NavigationLink(destination: CapacitorView(capacitor_id: capacitor.id!,capacitor_name: capacitor.name!, init_balance: capacitor.init_balance)) {
                                        HStack {
            //                                        Text(getDay(date: flowEntry.date!))
            //                                            .foregroundColor(.gray).font(.title3)
            //                                            .padding(.leading,5)
            //                                            .frame(width:30)
                                                
                                            VStack(alignment: .leading, spacing: 6){
                                                
                                             Text(capacitor.name!)
                                             

                                            }
                                            
                                            
                                            Spacer()
                                            
                                            if capacitor.balance > 0 {
                                                Text("¥ ") + Text("\(capacitor.balance)").foregroundColor(.green)
                                            } else if capacitor.balance < 0 {
                                                Text("¥ ") + Text("\(capacitor.balance)").foregroundColor(.red)
                                            } else {
                                                Text("¥ ") + Text("\(capacitor.balance)")
                                            }
                                            

                                        }
                                    }
                                    
                                }
                                
                            }.onDelete{
                                self.deleteCapacitor(at: $0, in: section)
                            }
                        }
                    }.listRowBackground(Color.background)
                    
                        
                
                
        }
                .listStyle(.plain).background(Color.background)

            }
            .navigationTitle("Capacitors")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Capacitor", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView){
                AddCapacitorView()
            }
        }
        .navigationViewStyle(.stack)
        
    }
        
    
    private func deleteCapacitor(at offsets: IndexSet, in capacitor: SectionedFetchResults<String, Capacitor>.Element){
        withAnimation{
            offsets.map { capacitor[$0] }.forEach(managedObjContext.delete)

            DataController().save(context: managedObjContext)
        }
    }
    
   
    
    
    
}

//struct CapacitorsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CapacitorsView()
//    }
//}



