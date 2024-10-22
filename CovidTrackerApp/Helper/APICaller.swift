//
//  APICaller.swift
//  CovidTrackerApp
//
//  Created by Linh Vu on 2/10/24.
//

import Foundation

enum DataScope {
    case national
    case state(State)
}

class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let allState = URL(string: "https://api.covidtracking.com/v2/states.json")
    }
    
    private init() {}
    
    // MARK: Get Covid Data
    func getCovidData(for scope: DataScope, completion: @escaping (Result<[DayData], Error>) -> Void) {
        let urlString: String
        
        switch scope {
        case .national: urlString = "https://api.covidtracking.com/v2/us/daily.json"
        case .state(let state):
            urlString = "https://api.covidtracking.com/v2/states/\(state.state_code.lowercased())/daily.json"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            do {
                let result = try JSONDecoder().decode(CovidDataResponse.self, from: data)
                
                let models: [DayData] = result.data.compactMap {
                    guard let value = $0.cases.total.value,
                            let date = DateFormatter.dayFormatter.date(from: $0.date) else {
                        return nil
                    }
                    
                    return DayData(date: date, count: value)
                }
                
                completion(.success(models))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: Get State List
    func getStateList(completion: @escaping (Result<[State], Error>) -> Void) {
        guard let url = Constants.allState else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            do {
                let result = try JSONDecoder().decode(StateListResponse.self, from: data)
                let states = result.data
                completion(.success(states))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
    
    static let prettyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
}
