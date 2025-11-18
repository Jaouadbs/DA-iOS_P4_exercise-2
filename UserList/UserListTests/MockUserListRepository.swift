//
//  MockUserListRepository.swift
//  UserListTests
//
//  Created by Jaouad on 14/11/2025.
//


@testable import UserList
import Foundation

/// Mock simple du repository pour les tests
/// Ce mock simule le comportement du vrai repository sans faire d'appels réseau
final class MockUserListRepository: UserListRepository {

    // Liste des utilisateurs que le mock va retourner
    var mockUsers: [User]

    // Pour savoir si fetchUsers a été appelé
    var fetchUsersWasCalled = false

    // Pour simuler une erreur si besoin
    var shouldReturnError = false

    // MARK: - Init

    init(initialUsers: [User] = []) {
        self.mockUsers = initialUsers
        // On appelle l'init du parent avec une closure vide
        super.init { _ in
            throw URLError(.badURL)
        }
    }

    // MARK: - Override fetchUsers

    override func fetchUsers(quantity: Int) async throws -> [User] {
        fetchUsersWasCalled = true

        if shouldReturnError {
            throw URLError(.badServerResponse)
        }

        return mockUsers
    }

    // MARK: - Helper pour créer des utilisateurs de test

    /// Crée des faux utilisateurs pour les tests
    /// - Parameter count: Nombre d'utilisateurs à créer
    /// - Returns: Liste d'utilisateurs de test
    static func createMockUsers(count: Int) -> [User] {
        return (0..<count).map { index in
            let apiUser = UserListResponse.User(
                name: .init(
                    title: "Mr",
                    first: "User\(index)",
                    last: "Test\(index)"
                ),
                dob: .init(
                    date: "1990-01-01",
                    age: 34
                ),
                picture: .init(
                    large: "https://example.com/large\(index).jpg",
                    medium: "https://example.com/medium\(index).jpg",
                    thumbnail: "https://example.com/thumb\(index).jpg"
                )
            )
            return User(user: apiUser)
        }
    }
}

