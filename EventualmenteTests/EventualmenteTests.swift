import XCTest
import FirebaseFirestore
@testable import Eventualmente

@MainActor
final class EventualmenteTests: XCTestCase {

    func testCreateAccountEmptyFields() throws {
        let viewModel = AuthenticationViewModel()
        viewModel.authFlow = .createAccount

        // Initial empty fields
        XCTAssertTrue(viewModel.areFieldsEmpty)

        // Fields with only whitespace
        viewModel.name = " "
        viewModel.email = " "
        viewModel.password = " "
        viewModel.passwordConfirmation = " "
        XCTAssertTrue(viewModel.areFieldsEmpty)

        // Not empty fields
        viewModel.name = "1"
        viewModel.email = "1"
        viewModel.password = "1"
        viewModel.passwordConfirmation = "1"
        XCTAssertFalse(viewModel.areFieldsEmpty)
    }

    func testCreateAccountValidation() throws {
        let viewModel = AuthenticationViewModel()
        viewModel.authFlow = .createAccount

        // Field validation: invalid password character number
        viewModel.name = "Nombre"
        viewModel.email = "email@example.com"
        viewModel.password = "1234"
        viewModel.passwordConfirmation = "1234"
        XCTAssertFalse(viewModel.validateFields())
        XCTAssertEqual(viewModel.errorMessage, "La contraseña debe tener entre 8 y 20 caracteres")

        // Field validation: password confirmation is different from password
        viewModel.password = "12345678"
        viewModel.passwordConfirmation = "12345677"
        XCTAssertFalse(viewModel.validateFields())
        XCTAssertEqual(viewModel.errorMessage, "Las contraseñas no coinciden")

        // Field validation: correct fields
        viewModel.passwordConfirmation = "12345678"
        XCTAssertTrue(viewModel.validateFields())
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testLogInEmptyFields() throws {
        let viewModel = AuthenticationViewModel()
        viewModel.authFlow = .logIn

        // Initial empty fields
        XCTAssertTrue(viewModel.areFieldsEmpty)

        // Fields with whitespace
        viewModel.email = " "
        viewModel.password = " "
        XCTAssertTrue(viewModel.areFieldsEmpty)

        // Not empty fields
        viewModel.email = "1"
        viewModel.password = "1"
        XCTAssertFalse(viewModel.areFieldsEmpty)
    }

    func testSortEvents() throws {
        let viewModel = ExploreViewModel()

        // Initial sorting
        if case .orderBy(let field, let value) = viewModel.allPredicates[1] {
            XCTAssertEqual(field, "date")
            XCTAssertEqual(value, false)
        } else {
            XCTFail("No sorting as second query predicate")
        }

        // Sort by category ascending
        viewModel.selectedSortOption = .categoryAZ
        viewModel.sortEvents()
        if case .orderBy(let field, let value) = viewModel.allPredicates[1] {
            XCTAssertEqual(field, "categoryName")
            XCTAssertEqual(value, false)
        } else {
            XCTFail("No sorting as second query predicate")
        }

        // Sort by category descending
        viewModel.selectedSortOption = .categoryZA
        viewModel.sortEvents()
        if case .orderBy(let field, let value) = viewModel.allPredicates[1] {
            XCTAssertEqual(field, "categoryName")
            XCTAssertEqual(value, true)
        } else {
            XCTFail("No sorting as second query predicate")
        }
    }

    func testUpdateViewMode() throws {
        let viewModel = ExploreViewModel()

        // Initial view mode
        XCTAssertEqual(viewModel.selectedViewMode, .list)
        XCTAssertTrue(viewModel.datePredicates.isEmpty)
        XCTAssertNil(viewModel.selectedDate)

        // Change to calendar view mode
        viewModel.selectedViewMode = .calendar
        viewModel.updateViewMode()
        XCTAssertEqual(viewModel.visibleMonth.month, Calendar.current.component(.month, from: .now))
        XCTAssertEqual(viewModel.datePredicates.count, 1)

        // Change to list view mode
        viewModel.selectedViewMode = .list
        viewModel.updateViewMode()
        XCTAssertTrue(viewModel.datePredicates.isEmpty)
        XCTAssertNil(viewModel.selectedDate)
    }

    func testFilterPredicates() throws {
        let viewModel = ExploreViewModel()

        // Initial filters
        XCTAssertTrue(viewModel.filterPredicates.isEmpty)
        XCTAssertFalse(viewModel.areFiltersApplied)
        XCTAssertEqual(viewModel.activeFilters, 0)

        // Add all possible filters
        let categoryName = "Category"
        let startDate = Date.now.addingTimeInterval(60)
        let endDate = Date.now.addingTimeInterval(120)

        viewModel.selectedCategoriesNames.insert(categoryName)
        viewModel.startDate = startDate
        viewModel.endDate = endDate
        viewModel.isEndDateSelected = true

        viewModel.addFilterPredicates()

        XCTAssertEqual(viewModel.filterPredicates.count, 3)
        XCTAssertTrue(viewModel.areFiltersApplied)
        XCTAssertEqual(viewModel.activeFilters, 3)
    }

    func testCalendarDecorations() throws {
        let viewModel = ExploreViewModel()

        let mockDateComponents: Set<DateComponents> = [
            .init(year: 2025, month: 1, day: 1),
            .init(year: 2026, month: 2, day: 7),
            .init(year: 2027, month: 9, day: 6),
            .init(year: 2029, month: 12, day: 31)
        ]

        var mockEvents: [Event] = []
        for mockDateComponent in mockDateComponents {
            mockEvents.append(.init(
                userId: "", groupId: "", usersFavourite: [], title: "", categoryName: "",
                categorySymbol: "", subcategoryName: "", location: "",
                date: Timestamp(date: Calendar.current.date(from: mockDateComponent)!), link: "", moreInfo: ""))
        }

        viewModel.addCalendarDecorations(events: mockEvents)
        XCTAssertEqual(viewModel.decoratedDates.count, mockDateComponents.count)
    }

    func testEventFormValidationPublicEvent() throws {
        let publicEventVM = EventFormViewModel(type: .create(userId: "userId", groupId: ""))

        // Initial empty fields
        XCTAssertFalse(publicEventVM.isFormValid)

        // Fields with only whitespace
        publicEventVM.title = " "
        publicEventVM.location = " "
        publicEventVM.link = " "
        publicEventVM.moreInfo = " "
        XCTAssertFalse(publicEventVM.isFormValid)

        // Date not selected
        publicEventVM.title = "Title"
        publicEventVM.selectedCategory = Category(name: "Category", symbolName: "category.symbol", subcategories: [])
        publicEventVM.location = "Location"
        publicEventVM.link = "Link"
        publicEventVM.moreInfo = "More information"
        XCTAssertFalse(publicEventVM.isFormValid)

        // Required fields filled (only link)
        publicEventVM.selectedDate = Date(timeIntervalSinceNow: 60)
        publicEventVM.moreInfo = ""
        XCTAssertTrue(publicEventVM.isFormValid)

        // Required fields filled (only more info)
        publicEventVM.link = ""
        publicEventVM.moreInfo = "More information"
        XCTAssertTrue(publicEventVM.isFormValid)
    }

    func testEventFormValidationPrivateEvent() throws {
        let privateEventVM = EventFormViewModel(type: .create(userId: "userId", groupId: "groupId"))

        // Initial empty fields
        XCTAssertFalse(privateEventVM.isFormValid)

        // Fields with only whitespace
        privateEventVM.title = " "
        XCTAssertFalse(privateEventVM.isFormValid)

        // Required fields filled
        privateEventVM.title = "Title"
        privateEventVM.selectedDate = Date(timeIntervalSinceNow: 60)
        XCTAssertTrue(privateEventVM.isFormValid)
    }
}
