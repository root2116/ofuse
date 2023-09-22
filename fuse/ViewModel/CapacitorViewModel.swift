//
//  CapacitorViewModel.swift
//  Fuse
//
//  Created by araragi943 on 2023/09/21.
//

import Combine
import CoreData

class CapacitorViewModel: ObservableObject {

    // 公開するプロパティ
    @Published var showingAddView: Bool = false
    @Published var sum: Int = 0
    // ... その他必要なプロパティ

    private var cancellables: Set<AnyCancellable> = []
    private var managedObjContext: NSManagedObjectContext
    
    var capacitorId: UUID
    var capacitorName: String

    init(capacitorId: UUID, capacitorName: String, context: NSManagedObjectContext) {
        self.capacitorId = capacitorId
        self.capacitorName = capacitorName
        self.managedObjContext = context
        setupBindings()
    }

    // 公開するメソッド
    func toggleAddView() {
        self.showingAddView.toggle()
    }

    func deleteCharge(at offsets: IndexSet, in section: SectionedFetchResults<String, Charge>.Element) {
        //...
        // 関数の実装は既存のCapacitorViewから移行する
    }

    //... その他必要なメソッド
    
    // プライベートなメソッドや変数
    private func setupBindings() {
        // Combineを使ってバインディングをセットアップ
    }
}
