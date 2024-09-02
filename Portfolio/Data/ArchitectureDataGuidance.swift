//
//  ArchitectureDataGuidance.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

/*:
 
 Data layer
 
 The data layer manages the storage and retrieval of information used by the application. It communicates with databases, external APIs, and other sources to fetch or save data. Within this layer, you’ll encounter two crucial elements:
 
 1. DataSource
 2. Repository
 
 The DATA layer contains the implementation of the repository as well as data sources, both from local sources (such as CoreData, SQLite, etc.) and remote sources (APIs).
 
 Datasource refers to the place where the application gets its information, like APIs or local databases. It can also hold forms of data like the answers received from APIs or databases. Because we can’t control how data is shaped and stored in an outside data source, it’s crucial to perform mapping on these response outcomes before sending them to the domain layer.

 source: https://medium.com/@walfandi/a-beginners-guide-to-clean-architecture-in-ios-building-better-apps-step-by-step-53e6ec8b3abd
 
 */
