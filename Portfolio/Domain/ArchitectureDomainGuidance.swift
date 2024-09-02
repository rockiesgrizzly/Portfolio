//
//  ArchitectureDomainGuidance.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

/*:
 
 Domain layer
 
 Here, the core business logic and rules reside. It defines how key functions work, reflecting the app’s unique purpose. This layer remains independent of external factors like user interfaces or databases. It consists of two vital parts:
 
 1. Use Cases
 2. Entities
 3. Models
 
 Model is a representation of real-world objects related to the problem. To put it simply, models are like the main characters in a story.
 
 Repository acts as an intermediary between the Domain Layer and external data sources such as databases, APIs, or file storage. It stores specific operations related to models. You can imagine a repository like a librarian; they know where the books are and how to retrieve and store the necessary ones.The actual implementation of the repository will be kept within the Data Layer.
 
 Usecase contains list of functionality of our application.

 source: https://medium.com/@walfandi/a-beginners-guide-to-clean-architecture-in-ios-building-better-apps-step-by-step-53e6ec8b3abd
 
 */
