import SwiftUI

struct Chips: View {
    let systemImage: String  //pass system image
    let titleKey: String //text or localisation value
    var isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(titleKey).font(metropolisRegularSM).lineLimit(1)
        }.padding(.all, 6)
        .foregroundColor(isSelected ? .white : pColor)
        .background(isSelected ? pColor : Color.white) //different UI for selected and not selected view
        .cornerRadius(40)  //rounded Corner
        .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(pColor, lineWidth: 1)
        
        ).onTapGesture {
            onTap()
        }
    }
}
