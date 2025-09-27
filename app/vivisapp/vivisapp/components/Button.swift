//
//  Button.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/14/25.
//
import SwiftUI

struct StandardButton : View {
    var text : String
    var onPress : () -> Void
    
    var width : CGFloat?
    var height: CGFloat?
    
    var body : some View {
        Button (action: onPress, label: { Text(text) }).font(
            .system(size: 17)
            .weight(.medium)
        )
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .frame(width: width ?? 342, height: height ?? 58, alignment: .center)
        .background(Color.black)
        .cornerRadius(25)
    }
}


#Preview {
    StandardButton(text: "Test") {
        
    }
}
