//
//  ConductorsView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI

struct ConductorsView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    
    @SectionedFetchRequest<String,Conductor>(
        sectionIdentifier: \.category!,
        sortDescriptors: [
            SortDescriptor(\.nextToPay),
            ]) private var conductors
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
//                Text("Balance: \(totalBalance()) yen")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
                List {
                    ForEach(conductors) { section in
                        Section(section.id){
                            ForEach(section){ conductor in
                                ConductorView(conductor: conductor)
                                
                            }.onDelete{
                                self.deleteConductor(at: $0, in: section)
                            }
                        }
                    }
//                    .onDelete(perform: deleteCapacitor)
        }
        .listStyle(.plain)

            }
            .navigationTitle("Conductors")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add a conductor", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView){

                AddConductorView(from: capacitors[0].id!)
            }
        }
        .navigationViewStyle(.stack)
        
    }
    
    
    private func deleteConductor(at offsets: IndexSet, in conductor: SectionedFetchResults<String, Conductor>.Element) {
        withAnimation{
            offsets.map { conductor[$0] }.forEach(managedObjContext.delete)

            DataController().save(context: managedObjContext)
        }
        
    }
    
    
    private func categoryList() -> [String] {
        var category_set: Set<String> = []
        
        for section in conductors {
            for conductor in section {
                if !category_set.contains(conductor.category!) {
                    category_set.insert(conductor.category!)
                }
            }
        }
        
        return Array(category_set)
    }
}

struct ConductorsView_Previews: PreviewProvider {
    static var previews: some View {
        ConductorsView()
    }
}
