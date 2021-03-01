//
//  ContentView.swift
//  VectorDrawing
//
//  Created by Chris Eidhof on 22.02.21.
//

import SwiftUI

extension Path {
    var elements: [Element] {
        var result: [Element] = []
        forEach { result.append($0) }
        return result
    }
}

extension Path.Element: Identifiable { // hack
    public var id: String { "\(self)" }
}

struct PathPoint: View {
    var element: Path.Element
    
    var body: some View {
        switch element {
        case let .line(point),
             let .move(point):
            Circle()
                .stroke(Color.black)
                .background(Circle().fill(Color.white))
                .padding(2)
                .frame(width: 14, height: 14)
                .offset(x: point.x-7, y: point.y-7)
        default:
            EmptyView()
        }
    }
}

struct Points: View {
    var path: Path
    var body: some View {
        ForEach(path.elements) { element in
            PathPoint(element: element)
        }
    }
}

struct Drawing: View {
    @State var path = Path()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
            path.stroke(Color.black, lineWidth: 2)
            Points(path: path)
        }.gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded { state in
                    if path.isEmpty {
                        path.move(to: state.startLocation)
                    } else {
                        path.addLine(to: state.startLocation)
                    }
                }
        )
    }
}

struct ContentView: View {
    var body: some View {
        Drawing()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
