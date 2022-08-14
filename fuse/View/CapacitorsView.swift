//
//  CapacitorsView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI



struct CapacitorsView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitor: FetchedResults<Capacitor>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
//                Text("Balance: \(totalBalance()) yen")
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
                List {
                    ForEach(capacitor) { capacitor in
                        NavigationLink(destination: CapacitorView(capacitor: capacitor)) {
                            HStack {
//                                        Text(getDay(date: flowEntry.date!))
//                                            .foregroundColor(.gray).font(.title3)
//                                            .padding(.leading,5)
//                                            .frame(width:30)
                                    
                                VStack(alignment: .leading, spacing: 6){
                                    
                                 Text(capacitor.name!)


                                }
                                Spacer()

                            }
                        }
                    }.onDelete(perform: deleteCapacitor)
        }
        .listStyle(.plain)

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
        .onAppear{
            registSampleData(context: managedObjContext)
        }
    }
        
    
    private func deleteCapacitor(at offsets: IndexSet){
        withAnimation{
            offsets.map { capacitor[$0] }.forEach(managedObjContext.delete)

            DataController().save(context: managedObjContext)
        }
    }
    
    
}

struct CapacitorsView_Previews: PreviewProvider {
    static var previews: some View {
        CapacitorsView()
    }
}
