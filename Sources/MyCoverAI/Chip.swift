import SwiftUI

struct Chips: View {
    let systemImage: String  //pass system image
    let titleKey: String //text or localisation value
    var isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(titleKey).font(spaceGroteskRegular13).lineLimit(1)
        }.padding(.horizontal, 8)
            .frame(minWidth: 71, minHeight: 28)
            .foregroundColor(isSelected ? .white : filterTextColor)
            .background(isSelected ? colorPrimary : Color.white) //different UI for selected and not selected view
            .cornerRadius(40)  //rounded Corner
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(isSelected ? colorPrimary : searchBorderColor, lineWidth: 1)
        
        ).onTapGesture {
            onTap()
        }
    }
}
