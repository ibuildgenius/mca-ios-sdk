//
//  TabLayoutView.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 27/01/2023.
//

import Foundation

import SwiftUI


// MARK:- Tab Layout View
struct TabLayoutView: View {
    
    // data model to draw TabLayout View
    var dataModel: TabDataModel
    
    // action on tab select
    var action: (Int) -> Void
    
    // variable to store selectTab index
    @State private var selectedTab: Int = 0
    
    var body: some View {
        
        // Add scrollView horizontally
            
            // Add ScrollViewReader to scroll ScrollView at a specific position programmatically
            ScrollViewReader { scrollView in
                
                // Add Tag Views in Horizontal stack
                HStack(spacing: dataModel.spacingBetweenTabs) {
                    
                    // Loop number of tabs to draw
                    ForEach(0..<dataModel.tabTitles.count) { index in
                        
                        // Draw Tag View
                        SingleTagView(tagIndex: index, dataModel: dataModel, currentSelectedIndex: selectedTab, action: { tappedIndex in
                            
                            // set selected tab index on action callback
                            self.selectedTab = tappedIndex
                            action(tappedIndex)
                            
                            // Scroll selected tab position in center with animation
                            withAnimation {
                                scrollView.scrollTo(self.selectedTab, anchor: .center)
                            }
                            
                        })
                        // Add unique id to Tag View for ScrollView to scroll it
                        .id(index)
                    }
                }
                // Padding to HStack
                .padding([.leading,.trailing],dataModel.paddingLeftRight)
                .padding([.top,.bottom],2)
            }
       
    }
}

// MARK:- Tag View
struct SingleTagView: View {
    
    // Properties
    // (tag index number, data model, current selected tag index, action closure)
    let tagIndex: Int
    var dataModel: TabDataModel
    var currentSelectedIndex: Int
    var action: (Int) -> Void
    
    // check is it already selected tag
    private var isThisTagSelected: Bool { get { return (currentSelectedIndex == tagIndex) } }
    
    var body: some View {
        
        // Tag button
      
            // Draw Tag button UI (title, textColor, padding)
            Text(dataModel.tabTitles[tagIndex])
                .foregroundColor(isThisTagSelected ? dataModel.selectedTabDataModel.textColor : dataModel.unselectedTabDataModel.textColor)
                .padding()
                .font(metropolisMedium)
        .onTapGesture {
            action(tagIndex)
        }
        // Add tag button properties (frame, backgroundColor, cornerRadious, border with color & corner)
        .frame(minHeight: 10, maxHeight: .infinity)
        .background(isThisTagSelected ? dataModel.selectedTabDataModel.backgroundColor : dataModel.unselectedTabDataModel.backgroundColor)
        .cornerRadius(CGFloat(isThisTagSelected ? dataModel.selectedTabDataModel.cornerRadius : dataModel.unselectedTabDataModel.cornerRadius))
       
    }
}

//MARK:- Preview
struct TabLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        
        let sModel = SelectedTabDataModel(textColor: .pink, backgroundColor: Color.pink.opacity(0.3), borderColor: .pink, borderWidth: 1, cornerRadius: 25)
        let uModel = UnSelectedTabDataModel(textColor: .gray, backgroundColor: Color.gray.opacity(0.3), borderColor: .gray, borderWidth: 1, cornerRadius: 25)
        let dataModel = TabDataModel(tabTitles: ["Tab 1", "Tab 2", "Tab 3", "Tab 4", "Tab 5", "Tab 6", "Tab 7", "Tab 8"], spacingBetweenTabs: 10, paddingLeftRight: 10, selectedTabDataModel: sModel, unselectedTabDataModel: uModel)
        
        TabLayoutView(dataModel: dataModel, action: { index in
            
        })
    }
}
