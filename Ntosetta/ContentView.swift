//
//  ContentView.swift
//  Ntosetta
//
//  Created by Pantos, Thomas on 13/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
     
        LoginView().accessibilityIdentifier("LoginView")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
