//
//  SearchBarView.swift
//  TrackMyCrypto
//
//  Created by Marc Boanas on 20/10/2022.
//

import SwiftUI

fileprivate enum Field: Int, Hashable {
    case search
}

struct SearchBarView: View {
    
    @Binding var searchText: String
    @FocusState private var focusedField: Field?
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? Color.Theme.secondaryText : .accentColor)
            TextField("Eg. Bitcoin or BTC", text: $searchText)
                .focused($focusedField, equals: .search)
                .autocorrectionDisabled()
                .foregroundColor(.accentColor)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .foregroundColor(.accentColor)
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            focusedField = nil
                            searchText = ""
                        }
                }
                .onAppear {
                    //focusedField = .search
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .font(.headline)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.Theme.background)
                .shadow(color: Color.accentColor.opacity(0.85), radius: 5, x: 0, y: 0)
        }
        .padding()
        .frame(minHeight: 80)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant("BTC"))
            .previewLayout(.sizeThatFits)
    }
}
