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
            SortDescriptor(\.next),
            ]) var conductors : SectionedFetchResults<String,Conductor>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
//                Text("Balance: \(totalBalance()) yen")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
                List {
                    ForEach(conductors, id: \.id) { section in
                        Section(section.id){
                            ForEach(section){ conductor in
                                ConductorView(conductor: conductor)
                                
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
    
    
    private func deleteConductor() {
        
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
