import SwiftUI

struct HourRow: View {
    let hour: Int
    let displayText: String
    let onTap: () -> Void
    
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
            onTap()
        }
    }
}

#Preview {
    VStack {
        HourRow(hour: 9, displayText: "5") { }
        HourRow(hour: 10, displayText: "-") { }
        HourRow(hour: 23, displayText: "3") { }
    }
}