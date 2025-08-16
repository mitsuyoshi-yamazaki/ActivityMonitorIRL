import SwiftUI

struct HourRow: View {
    let hour: Int
    let displayText: String
    let onTap: () -> Void
    let onTextInput: () -> Void
    
    var body: some View {
        HStack {
            Text("\(hour):00")
                .font(.title3)
                .fontWeight(.medium)
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            Text(displayText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(displayText == "-" ? .gray : .primary)
                .frame(width: 40, alignment: .center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .contentShape(Rectangle())
        .onTapGesture {
            if displayText == "-" {
                onTap()
            } else {
                onTextInput()
            }
        }
    }
}

#Preview {
    VStack {
        HourRow(hour: 9, displayText: "5") { } onTextInput: { }
        HourRow(hour: 10, displayText: "-") { } onTextInput: { }
        HourRow(hour: 23, displayText: "3") { } onTextInput: { }
    }
}