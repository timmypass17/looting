//
//  HistoryView.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/29/24.
//

import SwiftUI
import Charts

struct HistoryView: View {
    static let reuseIdentifier = "HistoryView"
    let history: [History]
    let yearInSeconds = 31536000
    
    var regular: Double? {
        return history.first?.deal.regular.amount
    }
    
    var lowest: Double? {
        return history.min { $0.deal.price.amountInt < $1.deal.price.amountInt }?.deal.price.amount
    }
    
    // To support < iOS 17
    var historyFromLastTwoYears: [History] {
        let currentYear = Calendar.current.component(.year, from: Date())

        let historyFromLastThreeYears = history.filter { item in
            let year = Calendar.current.component(.year, from: item.timestamp)
            return (currentYear - 2)...currentYear ~= year
        }
        
        return historyFromLastThreeYears
    }
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Chart {
                if let regular {
                    RuleMark(
                        y: .value("Regular", regular)
                    )
                    .foregroundStyle(by: .value("Price", "Regular"))
                    
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 10]))
                }
                
                if let lowest {
                    RuleMark(
                        y: .value("Lowest", lowest)
                    )
                    .foregroundStyle(by: .value("Price", "Lowest"))
                    
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 10]))
                }
                
                ForEach(history, id: \.timestamp) { item in
                    LineMark(
                        x: .value("Timestamp", item.timestamp),
                        y: .value("Price", item.deal.price.amount)
                    )
                    .interpolationMethod(.stepStart)
                    .foregroundStyle(by: .value("Shop", "Steam"))
                }
            }
            // Scroll only on iOS 17
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: yearInSeconds)
            .chartScrollPosition(initialX: Date.now)
            .chartYAxis {
                AxisMarks(position: .automatic, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                    AxisValueLabel() {
                        if let intValue = value.as(Int.self) {
                            Text("$\(intValue)")
                                .font(.system(size: 10))
                        }
                    }
                }
                
                
            }
        } else {
            Chart {
                if let regular {
                    RuleMark(
                        y: .value("Regular", regular)
                    )
                    .foregroundStyle(by: .value("Price", "Regular"))
                    
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 10]))
                }
                
                if let lowest {
                    RuleMark(
                        y: .value("Lowest", lowest)
                    )
                    .foregroundStyle(by: .value("Price", "Lowest"))
                    
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 10]))
                }
                
                ForEach(historyFromLastTwoYears, id: \.timestamp) { item in
                    LineMark(
                        x: .value("Timestamp", item.timestamp),
                        y: .value("Price", item.deal.price.amount)
                    )
                    .interpolationMethod(.stepStart)
                    .foregroundStyle(by: .value("Shop", "Steam"))
                }
            }
            .chartYAxis {
                AxisMarks(position: .automatic, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                    AxisValueLabel() {
                        if let intValue = value.as(Int.self) {
                            Text("$\(intValue)")
                                .font(.system(size: 10))
                        }
                    }
                }
                
                
            }
        }
    }
}

#Preview {
    let history: [History] = try! JSONDecoder().decode([History].self, from: steamHistory)
    return HistoryView(history: history)
}
