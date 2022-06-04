//
//  HealthManager.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 03/06/2022.
//

import Combine
import Foundation
import HealthKit
import UserNotifications

protocol HealthManagerProtocol {
    func needsAccessRequest() -> Bool
    func requestAccess() -> AnyPublisher<Bool, HealthError>
    func getWorkouts(for date: Date) -> AnyPublisher<[HKWorkout], HealthError>
}

// Possible errors that can occur
enum HealthError: Error {
    case notAuthorized
    case failedAutorizing
    case cantSaveEmpty
    case emptyResult
    case failedReadingDate(with: Error)
}

enum HealthType: CaseIterable {
    case workout
    case swimmingDistance
    case swimmingStrokeCount

    fileprivate func toObjectType() -> HKObjectType {
        switch self {
        case .workout:
            return .workoutType()
        case .swimmingDistance:
            return .quantityType(forIdentifier: .distanceSwimming)!
        case .swimmingStrokeCount:
            return .quantityType(forIdentifier: .swimmingStrokeCount)!
        }
    }
}

class HealthManager: HealthManagerProtocol {
    private let healthStore = HKHealthStore()
    private let readTypes: Set<HKObjectType> = Set(HealthType.allCases.map { $0.toObjectType() })

    func needsAccessRequest() -> Bool {
        HealthType.allCases.contains { current in
            healthStore.authorizationStatus(for: current.toObjectType()) == .notDetermined
        }
    }

    func requestAccess() -> AnyPublisher<Bool, HealthError> {
        return Future<Bool, HealthError> { [unowned self] promise in
            healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
                if error != nil {
                    return promise(.failure(.failedAutorizing))
                }
                return promise(.success(success))
            }
        }.eraseToAnyPublisher()
    }

    func getWorkouts(for date: Date) -> AnyPublisher<[HKWorkout], HealthError> {
        Future { [unowned self] promise in
            let sampleType = HKWorkoutType.workoutType()

            // Get the date one week ago.
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.day = components.day! - 7
            let oneWeekAgo = calendar.date(from: components)

            // Create a predicate for all samples within the last week.
            let inLastWeek = HKQuery.predicateForSamples(withStart: oneWeekAgo,
                                                         end: nil,
                                                         options: [.strictStartDate])
            let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            
            // Create the query.
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: inLastWeek,
                                      limit: 12,
                                      sortDescriptors: sortDescriptors) { query, results, error in
                if let error = error {
                    promise(.failure(.failedReadingDate(with: error)))
                }
                guard let results = results as? [HKWorkout], !results.isEmpty else {
                    return promise(.failure(.emptyResult))
                }
                promise(.success(results))
            }
            healthStore.execute(query)
        }
        .eraseToAnyPublisher()
    }
}
