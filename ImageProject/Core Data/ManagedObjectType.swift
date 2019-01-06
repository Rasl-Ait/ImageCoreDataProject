//
//  ManagedObjectType.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import Foundation

protocol ManagedObjectType: class {
	static var entityName: String { get }
}

extension Photo: ManagedObjectType {
	static var entityName: String {
		return "Photo"
	}
}
