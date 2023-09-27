//
//  CategoryListView.swift
//  Fuse
//
//  Created by araragi943 on 2023/09/27.
//

import SwiftUI

struct CategoryChargeListView: View {
    
    var charges: [Charge]
    
    @Binding var isButtonVisible: Bool
    
    var body: some View {
        List{
            ForEach(charges, id: \.self){ charge in
                BalanceChargeView(charge: charge, isButtonVisible: $isButtonVisible)
            }
        }.listStyle(.plain)
    }
}

