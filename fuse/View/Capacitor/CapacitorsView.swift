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
    var items : [Charge]
}



struct CapacitorsView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)], predicate: NSPredicate(format: "name != 'Ground' && name != 'Source'")) var capacitors: FetchedResults<Capacitor>
    
    @State private var showingAddView = false
    @State private var showingEditView = false
    @State var editMode: EditMode = .inactive
    
//    @SectionedFetchRequest<String,Capacitor>(
//                            sectionIdentifier: \.typeText,
//                            sortDescriptors: [
//                                SortDescriptor(\.type, order:.reverse),
//                                SortDescriptor(\.createdAt, order: .reverse)
//                            ]
//                           )  private var capacitors
//
    @State private var showingDeleteAlert = false
    @State private var showingAddChargeView = false
    
    @State private var capacitorToDelete:Capacitor?
    
    @State private var capacitorToEdit: Capacitor? = nil
    @State private var isButtonVisible = true
    @State private var selectedCapacitor: UUID? = gndId!
    
    
    @State private var page: Int? = 0
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .leading) {
                    //                Text("Balance: \(totalBalance()) yen")
                    //                    .foregroundColor(.gray)
                    //                    .padding(.horizontal)
                    List {
                        
                        //                    ForEach(capacitors) { section in
                        //                        Section(section.id) {
                        //                            ForEach(section) { capacitor in
                        ForEach(capacitors, id: \.id){ capacitor in
                            
                            
                            NavigationLink(destination: CapacitorView(capacitorId: capacitor.id!,capacitorName: capacitor.name!, isButtonVisible: $isButtonVisible, selectedCapacitor: $selectedCapacitor)) {
                                HStack {
                                    //                                        Text(getDay(date: ChargeEntry.date!))
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
                            }.contextMenu {
                                Button {
                                    //                                                  capacitorToEdit = capacitor
                                    capacitorToEdit = capacitor
                                    
                                    
                                    
                                } label: {
                                    Text("Edit")
                                }
                                Button(role: .destructive) {
                                    
                                    
                                    capacitorToDelete = capacitor
                                } label: {
                                    Text("Delete")
                                }
                            }
                            .alert(item: $capacitorToDelete) { capacitor in
                                Alert(title: Text("Warning"),
                                      message: Text("Are you sure you want to delete this capacitor?"),
                                      primaryButton: .cancel(Text("Cancel")),    // キャンセル用
                                      secondaryButton: .destructive(Text("Delete"),action: {
                                    withAnimation{
                                        
                                        let in_charges = capacitor.in_charges
                                        let out_charges = capacitor.out_charges
                                        
                                        for in_charge in chargeArray(in_charges) {
                                            DataController.shared.deleteCharge(charge: in_charge, context: managedObjContext)
                                        }
                                        
                                        for out_charge in chargeArray(out_charges){
                                            DataController.shared.deleteCharge(charge: out_charge, context: managedObjContext)
                                        }
                                        managedObjContext.delete(capacitor)
                                        DataController.shared.save(context: managedObjContext)
                                    }
                                    
                                    
                                }))   // 破壊的変更用
                            }
                            //                                    .confirmationDialog(
                            //                                        Text("Are you sure?"),
                            //                                        isPresented: $showingDeleteAlert,
                            //                                        titleVisibility: .visible
                            //                                    ) {
                            //                                         Button("Delete", role: .destructive) {
                            //
                            ////                                         self.deleteCapacitor(at: toDeleteAt!, in: toDeleteIn!)
                            //                                             withAnimation {
                            //                                                 managedObjContext.delete(capacitorToDelete!)
                            //                                                 DataController.shared.save(context: managedObjContext)
                            //
                            //                                            }
                            //
                            //
                            //
                            //
                            //                                    }
                            //                                }
                            
                            
                            
                            
                            
                            
                            //                            .onDelete(perform: editMode.isEditing ? {
                            //                                toDeleteAt = $0
                            //                                toDeleteIn = section
                            //                                showingDeleteAlert = true
                            ////                                self.deleteCapacitor(at: $0, in: section)
                            //
                            //
                            //                            }: nil)
                            
                        }
                        //                    .listRowBackground(Color.background)
                        
                        
                        
                        
                    }
                    .listStyle(.plain)
                    //                .background(Color.background)
                    
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
                    //                ToolbarItem(placement: .navigationBarLeading){
                    //                    EditButton()
                    //                }
                }
                .environment(\.editMode, $editMode)
                .sheet(isPresented: $showingAddView){
                    AddCapacitorView()
                }.sheet(item: self.$capacitorToEdit){
                    EditCapacitorView(capacitor: $0)
                    
                }
                
                
            }
            .navigationViewStyle(.stack)
            .sheet(isPresented: $showingAddChargeView){
                AddChargeView(openedCapId: $selectedCapacitor)
            }
            
            if isButtonVisible {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showingAddChargeView.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.green)
                                .background(Color.white)
                                .clipShape(Circle())
                                .padding()
                        }
                    }
                }
            }
        }
//
    }
        
    
    private func deleteCapacitor(at offsets: IndexSet, in capacitor: SectionedFetchResults<String, Capacitor>.Element){
        withAnimation{
            
            offsets.map { capacitor[$0] }.forEach(managedObjContext.delete)

            DataController.shared.save(context: managedObjContext)
            
        }
    }
    
   
    
    
    
}

//struct CapacitorsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CapacitorsView()
//    }
//}



