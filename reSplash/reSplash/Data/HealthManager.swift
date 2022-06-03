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
    func requestAccess() async throws
    func getWorkouts(for date: Date) -> AnyPublisher<[HKWorkout], HealthError>
}

// Possible errors that can occur
enum HealthError: Error {
    case notAuthorized
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
    static let shared = HealthManager()

    private let healthStore = HKHealthStore()

    private let readTypes: Set<HKObjectType> = Set(HealthType.allCases.map { $0.toObjectType() })

    func needsAccessRequest() -> Bool {
        HealthType.allCases.contains { current in
            healthStore.authorizationStatus(for: current.toObjectType()) == .notDetermined
        }
    }

    func requestAccess() async throws {
        try await healthStore.requestAuthorization(toShare: [],
                                                   read: readTypes)
    }

    func getWorkouts(for date: Date) -> AnyPublisher<[HKWorkout], HealthError> {
        Future { [unowned self] promise in
            let sampleType = HKSampleType.workoutType()
            guard healthStore.authorizationStatus(for: sampleType) == .sharingAuthorized else {
                promise(.failure(HealthError.notAuthorized))
                return
            }

            let calendar = Calendar.current
            let components = calendar.dateComponents([.calendar, .year, .month, .day],
                                                     from: date)

            let startDate = calendar.date(from: components)!
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

            let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]

            // Create the query.
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: today,
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
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
