//
//  AddCategoryView.swift
//  Fuse
//
//  Created by araragi943 on 2023/03/09.
//

import SwiftUI

struct AddCategoryView: View {
    
    @Binding var category : UUID?
    
    @State private var categoryName : String = ""
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            
            
            List{
                TextField("Category name", text: $categoryName )
                
                
            }.toolbar{
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        
                        let cat = DataController().addCategory(name: categoryName, context: managedObjContext)
                        category = cat.id
                        dismiss()
                    } label: {
                        Text("Add")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }.navigationTitle("Add Category")
        }
    }
}

//struct AddCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCategoryView()
//    }
//}
