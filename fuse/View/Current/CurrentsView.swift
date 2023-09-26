//
//  CurrentsView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI


extension Current {
    @objc
    var spanText: String {
        if self.span == "day" {
            return "Daily"
        } else if self.span == "week" {
            return "Weekly"
        } else if self.span == "month" {
            return "Monthly"
        } else {
            return "Yearly"
        }
    }
}
struct CurrentsView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    
    @SectionedFetchRequest<String,Current>(
        sectionIdentifier: \.spanText,
        sortDescriptors: [
            SortDescriptor(\.createdAt, order: .reverse)
            ]) private var currents
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) private var currents: FetchedResults<Current>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @State private var showingAddView = false
    @State private var isButtonVisible = true
    @State private var showingAddChargeView = false
    @State private var lastUsedCapacitorId: UUID?
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .leading) {
    //                Text("Balance: \(totalBalance()) yen")
    //                    .foregroundColor(.gray)
    //                    .padding(.horizontal)
                    List {
                        ForEach(currents) { section in
                            Section(header: HStack{
                                Text("\(section.id)")
                                Spacer()
                                Text("Total: ¥ \(sumCurrent(currents:section))")
                            }){
                                ForEach(section){ current in
                                    CurrentView(current: current, isButtonVisible: $isButtonVisible)
                                    
                                }.onDelete{
                                    self.deleteCurrent(at: $0, in: section)
                                }
                            }
                        }
    //                    .listRowBackground(Color.background)
    //                    .onDelete(perform: deleteCapacitor)
            }
                    .listStyle(.plain)
    //                .background(Color.background)

                }
                .navigationTitle("Currents")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            showingAddView.toggle()
                        } label: {
                            Label("Add a current", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        EditButton()
                    }
                }
                .sheet(isPresented: $showingAddView){

                    AddCurrentView()
                }
            }
            .navigationViewStyle(.stack)
            .sheet(isPresented: $showingAddChargeView){
                AddChargeView(openedCapId: $lastUsedCapacitorId)
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
            
        }.onAppear {
            self.lastUsedCapacitorId = DataController.shared.getLastUsedCapacitor(context: managedObjContext)
        }
        
        
    }
    
    private func sumCurrent(currents: SectionedFetchResults<String, Current>.Element) -> Int{
        
        var sum : Int32 = 0
        for current in currents{
            sum += current.amount
        }
        
        return Int(sum)
    }
    
    private func deleteCurrent(at offsets: IndexSet, in currents: SectionedFetchResults<String, Current>.Element) {
        withAnimation{
            
            
            offsets.map { currents[$0] }.forEach(managedObjContext.delete)
            
            
            DataController.shared.save(context: managedObjContext)
        }
        
    }
    
    
//    private func categoryList() -> [String] {
//        var category_set: Set<String> = []
//
//        for section in currents {
//            for current in section {
//                if !category_set.contains(current.tag!) {
//                    category_set.insert(current.tag!)
//                }
//            }
//        }
//
//        return Array(category_set)
//    }
}

//struct CurrentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentsView()
//    }
//}
