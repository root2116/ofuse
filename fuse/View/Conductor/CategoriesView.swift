//
//  CategoryView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/18.
//

import SwiftUI

struct CategoriesView: View {
    
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
   
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.createdAt, order: .reverse),
            ]) var categories : FetchedResults<Category>
    
    @Binding var selection : String
    @State private var showingAddView = false
    @State private var newName = ""
    
    @State private var enable: Bool = true
        
    var body: some View {
            VStack {
                
                Menu(selection) {
                    Button("New Category ...") {
                            showingAddView = true
                        }

                    ForEach(categories) { category in
                        Button(category.name!) { selection = category.name! }
                    }
                }
            }
            
            .sheet(isPresented: $showingAddView, content: {
                VStack(alignment: .leading) {
                    NavigationView{
                        
                    
                    Form{
                        Section {
                            TextField("New category name", text: $newName)
                            HStack{
                                Spacer()
                                Button("Save"){
                                    enable = false
                                    DataController().addCategory(name: newName, context: managedObjContext)
                                    selection = newName
                                    showingAddView = false
                                }.disabled(!enable)
                                Spacer()
                            }
                            
                        }
                    }.navigationTitle("Add a Category")
                        
                    }
                    
                }
            })
    }
        
    
    



    
//    private func categoryList() -> [CategoryItem] {
//        var category_set: Set<String> = []
//
//        for conductor in conductors {
//
//            if !category_set.contains(conductor.category!) {
//                category_set.insert(conductor.category!)
//            }
//
//        }
//
//        return Array(category_set).map{ CategoryItem(name: $0)}
//    }
    
//    struct CategoryItem: Identifiable, Hashable {
//            let id = UUID()
//            var name: String
//    }
}

//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}
