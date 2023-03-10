//
//  TagView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/18.
//

import SwiftUI

struct TagsView: View {
    
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
   
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.createdAt, order: .reverse),
            ]) var tags : FetchedResults<Tag>
    
    @Binding var selection : String
    @State private var showingAddView = false
    @State private var newName = ""
    
    @State private var enable: Bool = true
        
    var body: some View {
            VStack {
                
                Menu(selection) {
                    Button("New Tag ...") {
                            showingAddView = true
                        }

                    ForEach(tags) { tag in
                        Button(tag.name!) { selection = tag.name! }
                    }
                }
            }
            
            .sheet(isPresented: $showingAddView, content: {
                VStack(alignment: .leading) {
                    NavigationView{
                        
                    
                    Form{
                        Section {
                            TextField("New tag name", text: $newName)
                            HStack{
                                Spacer()
                                Button("Save"){
                                    enable = false
                                    DataController().addTag(name: newName, context: managedObjContext)
                                    selection = newName
                                    showingAddView = false
                                }.disabled(!enable)
                                Spacer()
                            }
                            
                        }
                    }.navigationTitle("Add a Tag")
                        
                    }
                    
                }
            })
    }
        
    
    



    
//    private func tagList() -> [TagItem] {
//        var tag_set: Set<String> = []
//
//        for conductor in conductors {
//
//            if !tag_set.contains(conductor.tag!) {
//                tag_set.insert(conductor.tag!)
//            }
//
//        }
//
//        return Array(tag_set).map{ TagItem(name: $0)}
//    }
    
//    struct TagItem: Identifiable, Hashable {
//            let id = UUID()
//            var name: String
//    }
}

//struct TagView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagView()
//    }
//}
