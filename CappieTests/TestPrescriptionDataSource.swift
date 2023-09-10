//
//  CappieTests.swift
//  CappieTests
//
//  Created by Yi Xu on 8/22/23.
//

import XCTest
@testable import Cappie
import CoreData

class MockDrugPrescriptionService: DrugPrescriptionServiceProvider {
    public var fetchDrugsBackgroundCalled = false
    
    func fetchDrugsBackground(fetch_offset: Int, action: @escaping ([NSManagedObject]) -> ()) {
        fetchDrugsBackgroundCalled = true
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DrugPrescription", in: context)
        let newDrug = NSManagedObject(entity: entity!, insertInto: context)
        newDrug.setValue("Test Drug", forKey: "name")
        newDrug.setValue(2, forKey: "dailyDosage")
        action([newDrug, ])
    }
    
    func removeDrugBackground(drugName: String, completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    func insertPrescription(prescription: DrugPrescriptionModel) {
        
    }
    
    func fetchDrug(for name: String, action: @escaping (NSManagedObject) -> ()) {
        
    }
}

final class TestPrescriptionDataSource: XCTestCase {
    var mockDrugPrescriptionService: MockDrugPrescriptionService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockDrugPrescriptionService = MockDrugPrescriptionService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNonAction() throws {
        XCTAssertFalse(mockDrugPrescriptionService.fetchDrugsBackgroundCalled)
    }
    
    func testLoadTableData() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let prescriptionDataSource = PrescriptionDataSource(drugPrescriptionService: mockDrugPrescriptionService)
        prescriptionDataSource.loadTableData(UITableView())
        XCTAssertTrue(mockDrugPrescriptionService.fetchDrugsBackgroundCalled)
        XCTAssertEqual(prescriptionDataSource.drugs, [DrugPrescriptionModel(name: "Test Drug", dailyDosage: 2)])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
