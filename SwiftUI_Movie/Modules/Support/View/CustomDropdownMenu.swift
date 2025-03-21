//
//  CustomDropdownMenu.swift
//  CustomDropdownMenu
//
//  Created by Everton Carneiro on 05/02/22.
//

import SwiftUI

struct CustomDropdownMenu: View {
    @State var isSelecting = false
    @State var selectionTitle = ""
    @State var selectedRowId = 0
    let items: [DropdownItem]
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    Text(selectionTitle)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .animation(.none)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                        .rotationEffect(.degrees( isSelecting ? -180 : 0))
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                
                if isSelecting {
                    Divider()
                        .background(.white)
                        .padding(.horizontal)
                    
                    VStack(spacing: 5) {
                        dropDownItemsList()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color(uiColor: UIColor.link))
            .cornerRadius(5)
            .onTapGesture {
                isSelecting.toggle()
            }
            .onAppear {
                selectedRowId = items[0].id
                selectionTitle = items[0].title
            }
            .animation(.easeInOut(duration: 0.3))
        }
    }
    
    private func dropDownItemsList() -> some View {
        ForEach(items) { item in
            DropdownMenuItemView(isSelecting: $isSelecting, selectionId: $selectedRowId, selectiontitle: $selectionTitle, item: item)
        }
    }
}

struct DropdownItem: Identifiable {
    let id: Int
    let title: String
    let onSelect: () -> Void
}

struct DropdownMenuItemView: View {
    @Binding var isSelecting: Bool
    @Binding var selectionId: Int
    @Binding var selectiontitle: String
    let item: DropdownItem
    
    var body: some View {
        Button(action: {
            isSelecting = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                selectionId = item.id
            }
            selectiontitle = item.title
            item.onSelect()
        }) {
            HStack {
                Text(item.title)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                Spacer()
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .opacity(selectionId == item.id ? 1 : 0)
            }
            .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
            .foregroundColor(.white)
        }
    }
}

struct CustomDropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomDropdownMenu(items: [
            DropdownItem(id: 1, title: "Messages", onSelect: {}),
            DropdownItem(id: 2, title: "Archived", onSelect: {}),
            DropdownItem(id: 3, title: "Trash", onSelect: {})
        ])
        .padding(.horizontal)
    }
}

extension View {
    func customDropdownMenu(items: [DropdownItem]) -> some View {
        ZStack {
            VStack {
                CustomDropdownMenu(items: items)
                    .padding(.horizontal)
                Spacer()
            }
            .zIndex(10)
            self
                .offset(y: 60)
                .padding(.bottom, 60)
                .zIndex(1)
        }
    }
}

