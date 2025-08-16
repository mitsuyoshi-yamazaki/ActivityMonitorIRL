import SwiftUI

struct HourRow: View {
    let hour: Int
    let displayText: String
    let activity: String?
    let onTap: () -> Void
    let onTextInput: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            
            if let activity {
                Text(activity)
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                     .frame(maxWidth: .infinity, alignment: .leading)
            }
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
        HourRow(hour: 9, displayText: "5", activity: "test activity") { } onTextInput: { }
        HourRow(hour: 10, displayText: "-", activity: nil) { } onTextInput: { }
        HourRow(hour: 23, displayText: "3", activity: nil) { } onTextInput: { }
    }
}
