//
//  ContentView.swift
//  MetricX
//
//  Created by utsav singh on 5/25/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputValue = 0.0
    @State private var inputUnitIndex = 0
    @State private var outputUnitIndex = 1
    @State private var category = "Length"

    let categories = ["Length", "Temperature", "Time", "Volume"]

    var units: [(name: String, symbol: String)] {
        switch category {
        case "Length":
            return [("Meters", "m"), ("Kilometers", "km"), ("Feet", "ft"), ("Yards", "yd"), ("Miles", "mi")]
        case "Temperature":
            return [("Celsius", "℃"), ("Fahrenheit", "℉"), ("Kelvin", "K")]
        case "Time":
            return [("Seconds", "s"), ("Minutes", "min"), ("Hours", "h"), ("Days", "d")]
        case "Volume":
            return [("Milliliters", "ml"), ("Liters", "l"), ("Cups", "cups"), ("Pints", "pt"), ("Gallons", "gal")]
        default:
            return []
        }
    }

    var convertedValue: Double {
        guard inputUnitIndex < units.count, outputUnitIndex < units.count else {
            return 0
        }

        let input = inputValue
        let from = units[inputUnitIndex].name
        let to = units[outputUnitIndex].name

        switch category {
        case "Length":
            let baseValue: Double = {
                switch from {
                case "Meters": return input
                case "Kilometers": return input * 1000
                case "Feet": return input * 0.3048
                case "Yards": return input * 0.9144
                case "Miles": return input * 1609.34
                default: return input
                }
            }()

            switch to {
            case "Meters": return baseValue
            case "Kilometers": return baseValue / 1000
            case "Feet": return baseValue / 0.3048
            case "Yards": return baseValue / 0.9144
            case "Miles": return baseValue / 1609.34
            default: return baseValue
            }

        case "Temperature":
            let celsius: Double = {
                switch from {
                case "Celsius": return input
                case "Fahrenheit": return (input - 32) * 5 / 9
                case "Kelvin": return input - 273.15
                default: return input
                }
            }()

            switch to {
            case "Celsius": return celsius
            case "Fahrenheit": return celsius * 9 / 5 + 32
            case "Kelvin": return celsius + 273.15
            default: return celsius
            }

        case "Time":
            let baseValue: Double = {
                switch from {
                case "Seconds": return input
                case "Minutes": return input * 60
                case "Hours": return input * 3600
                case "Days": return input * 86400
                default: return input
                }
            }()

            switch to {
            case "Seconds": return baseValue
            case "Minutes": return baseValue / 60
            case "Hours": return baseValue / 3600
            case "Days": return baseValue / 86400
            default: return baseValue
            }

        case "Volume":
            let baseValue: Double = {
                switch from {
                case "Milliliters": return input
                case "Liters": return input * 1000
                case "Cups": return input * 240
                case "Pints": return input * 473.176
                case "Gallons": return input * 3785.41
                default: return input
                }
            }()

            switch to {
            case "Milliliters": return baseValue
            case "Liters": return baseValue / 1000
            case "Cups": return baseValue / 240
            case "Pints": return baseValue / 473.176
            case "Gallons": return baseValue / 3785.41
            default: return baseValue
            }

        default:
            return input
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Category")) {
                    Picker("Conversion Type", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: category) {
                        inputUnitIndex = 0
                        outputUnitIndex = 1
                        inputValue = 0.0
                    }
                }

                Section(header: Text("Input Value")) {
                    TextField("Enter value (e.g. 12.5)", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .disabled(units.isEmpty)
                }

                Section(header: Text("From Unit")) {
                    Picker("From", selection: $inputUnitIndex) {
                        ForEach(0..<units.count, id: \.self) {
                            Text("\(units[$0].name) (\(units[$0].symbol))")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .disabled(units.isEmpty)
                }

                Section(header: Text("To Unit")) {
                    Picker("To", selection: $outputUnitIndex) {
                        ForEach(0..<units.count, id: \.self) {
                            Text("\(units[$0].name) (\(units[$0].symbol))")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .disabled(units.isEmpty)
                }

                Section(header: Text("Converted Result")) {
                    Text("\(convertedValue.formatted()) \(units[outputUnitIndex].symbol)")
                }
            }
            .navigationTitle("MatricX")
        }
    }
}

#Preview {
    ContentView()
}
