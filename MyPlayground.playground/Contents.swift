// https://swiftwithmajid.com/2023/04/11/mastering-canvas-in-swiftui

import PlaygroundSupport
import SwiftUI

struct ContentView: View {
    @State private var detail = false
    @Namespace private var ns

    var body: some View {
        ZStack {
            if detail {
                Color.red
                    .matchedGeometryEffect(id: "rect", in: ns)
                    .frame(width: 100, height: 100)
            } else {
                Color.red
                    .matchedGeometryEffect(id: "rect", in: ns)
                    .frame(width: 300, height: 300)
            }
        }
        .animation(.default, value: detail)
        .onTapGesture {
            detail.toggle()
        }
    }
}

// struct ContentView: View {
//    var body: some View {
//        Canvas(
//            opaque: true,
//            colorMode: .linear,
//            rendersAsynchronously: false
//        ) { context, size in
//            context.opacity = 0.3
//
//            let rect = CGRect(origin: .zero, size: size)
//
//            var path = Circle().path(in: rect)
//            context.fill(path, with: .color(.red))
//
//            let newRect = rect.applying(.init(scaleX: 0.5, y: 0.5))
//            path = Circle().path(in: newRect)
//            context.fill(path, with: .color(.red))
//        }.frame(width: 500, height: 500)
//    }
// }

// struct ContentView: View {
//    var body: some View {
//        TimelineView(.animation) { timelineContext in
//            let value = secondsValue(for: timelineContext.date)
//
//            Canvas(
//                opaque: true,
//                colorMode: .linear,
//                rendersAsynchronously: false
//            ) { context, size in
//                let newSize = size.applying(.init(scaleX: value, y: 1))
//                let rect = CGRect(origin: .zero, size: newSize)
//
//                context.fill(
//                    Rectangle().path(in: rect),
//                    with: .color(.red)
//                )
//            }.frame(width: 500, height: 500)
//        }
//    }
//
//    private func secondsValue(for date: Date) -> Double {
//        let seconds = Calendar.current.component(.second, from: date)
//        return Double(seconds) / 60
//    }
// }

PlaygroundPage.current.setLiveView(ContentView())
