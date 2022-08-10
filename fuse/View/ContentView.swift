//
//  ContentView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var flow: FetchedResults<Flow>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(totalBalance()) yen")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(flow) { flow in
                        NavigationLink(destination: EditFlowView(flow: flow)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6){
                                    Text(flow.name!)
                                        .bold()
                                    Text("\(Int(flow.amount))") + Text(" yen").foregroundColor(.red)
                        
                                }
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteFlow)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Fuse")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Flow", systemImage: "plus.circle")
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
    private func deleteFlow(offsets: IndexSet){
        withAnimation{
            offsets.map { flow[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    private func totalBalance() -> Int {
        var totalBalance = 0
        
        for item in flow {
            totalBalance += Int(item.amount)
        }
        return totalBalance
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
