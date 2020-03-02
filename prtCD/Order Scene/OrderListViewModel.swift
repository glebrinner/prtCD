

import Foundation


class OrderListViewModel: ObservableObject {
    
    @Published var currentSegment = OrderListView.Segment.today
    
    let segmentOptions: [OrderListView.Segment] = [.today, .upcoming, .pastDay(7)]
}
