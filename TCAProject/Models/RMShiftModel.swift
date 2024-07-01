//
//  RMJobModel.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/27/24.
//

import Foundation
import CoreLocation

// MARK: - shift response model
struct RMShiftModel: Decodable, Identifiable {
    let id: String?
    let earnings: String? // earnings_per_hour
    let startAt, endAt: String? // starts_at // ends_at -> example "2024-06-27T03:00:00+02:00"
    let job: RMJob?
    
    // initializer for creating mock data
    init(id: String, earnings: String? = nil, startAt: String? = nil, endAt: String? = nil, job: RMJob? = nil) {
        self.id = id
        self.earnings = earnings
        self.startAt = startAt
        self.endAt = endAt
        self.job = job
    }
    
    enum CodingKeys: String, CodingKey  {
        case id
        case earnings = "earnings_per_hour"
        case startAt = "starts_at"
        case endAt = "ends_at"
        case job
    }
    
    // earning per hour coding keys to use on decoding specific data
    enum EarningsPerHourCodingKeys: String, CodingKey {
        case currency
        case amount
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        self.startAt = try? container.decodeIfPresent(String.self, forKey: .startAt)?.convertISODateString()
        self.endAt = try? container.decodeIfPresent(String.self, forKey: .endAt)?.convertISODateString()
        
        self.job = try? container.decodeIfPresent(RMJob.self, forKey: .job)
        
        // decode earning per hour
        let RMEarningsPerHour = try container.nestedContainer(keyedBy: EarningsPerHourCodingKeys.self, forKey: .earnings)
        let RMEarningsPerHourCurrency = try RMEarningsPerHour.decode(String.self, forKey: .currency)
        let RMEarningsPerHourAmount = try RMEarningsPerHour.decode(Double.self, forKey: .amount)
        let currency = Currency(shorthand: RMEarningsPerHourCurrency).sign
        let format = "%@ %02.02f"
        self.earnings = String(format: format, currency, RMEarningsPerHourAmount)
    }
}

// MARK: - job response model
struct RMJob: Decodable {
    let id: String?
    let client: String?
    let imageURL: URL?
    let category: String?
    let address: RMAddress? // report_at_address
    
    enum CodingKeys: String, CodingKey {
        case id
        case project
        case category
        case address = "report_at_address"
    }
    
    enum ProjectKeys: String, CodingKey {
        case client
    }

    enum ClientKeys: String, CodingKey {
        case name
        case links
    }

    enum LinksKeys: String, CodingKey {
        case image = "hero_image"
    }

    enum CategoryKeys: String, CodingKey {
        case name = "name_translation"
    }

    enum NameTranslationKeys: String, CodingKey {
        case english = "en_GB"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let projectContainer = try container.nestedContainer(keyedBy: ProjectKeys.self, forKey: .project)

        let clientContainer = try? projectContainer.nestedContainer(keyedBy: ClientKeys.self, forKey: .client)
        let linksContainer = try? clientContainer?.nestedContainer(keyedBy: LinksKeys.self, forKey: .links)

        let categoryContainer = try? container.nestedContainer(keyedBy: CategoryKeys.self, forKey: .category)
        let nameContainer = try? categoryContainer?.nestedContainer(keyedBy: NameTranslationKeys.self, forKey: .name)
        
        id = try? container.decode(String.self, forKey: .id)
        address = try container.decode(RMAddress.self, forKey: .address)
        client = try? clientContainer?.decode(String.self, forKey: .name)
        category = (try? nameContainer?.decode(String.self, forKey: .english)) ?? (try? nameContainer?.decode(String.self, forKey: .english))
        imageURL = try? linksContainer?.decode(URL.self, forKey: .image)
    }
}


// MARK: - address response model
struct RMAddress: Decodable {
    let location: CLLocation?

    enum CodingKeys: String, CodingKey {
        case location = "geo"
    }

    enum CoordinateKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let coordinateContainer = try? container.nestedContainer(keyedBy: CoordinateKeys.self, forKey: .location)

        if let latitude = try? coordinateContainer?.decode(CLLocationDegrees.self, forKey: .latitude),
           let longitude = try? coordinateContainer?.decode(CLLocationDegrees.self, forKey: .longitude) {
            location = CLLocation(latitude: latitude, longitude: longitude)
        } else {
            location = nil
        }
    }
}

// MARK: - currency
enum Currency {
    case euro
    case dollar
    case unknown

    init(shorthand: String) {
        switch shorthand {
        case "EUR":
            self = .euro
        case "USD":
            self = .dollar
        default:
            self = .unknown
        }
    }

    var sign: String {
        switch self {
        case .euro:
            return "€"
        case .dollar:
            return "$"
        case .unknown:
            return "?"
        }
    }
}
