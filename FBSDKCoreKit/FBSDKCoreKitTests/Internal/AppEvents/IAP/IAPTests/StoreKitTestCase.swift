/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import FBSDKCoreKit
@testable import IAPTestsHostApp

import StoreKitTest
import XCTest

@available(iOS 14.0, *)
// swiftlint:disable:this test_classes_should_be_final
// swiftlint:disable:next prefer_final_classes
class StoreKitTestCase: XCTestCase {

  static let configFileName = "FBSDKStoreKitConfigurationUnitTests"

  enum ProductIdentifiers: String, CaseIterable {
    case consumableProduct1 = "com.fbsdk.consumable.p1"
    case nonConsumableProduct1 = "com.fbsdk.nonconsumable.p1"
    case nonConsumableProduct2 = "com.fbsdk.nonconsumable.p2"
    case autoRenewingSubscription1 = "com.fbsdk.autorenewing.s1"
    case autoRenewingSubscription2 = "com.fbsdk.autorenewing.s2"
    case nonRenewingSubscription1 = "com.fbsdk.nonrenewing.s1"
  }

  enum StoreKitTestCaseError: Error {
    case purchaseFailed
  }

  static var allIdentifiers = ProductIdentifiers.allCases.map { id in
    id.rawValue
  }

  // swiftlint:disable:next implicitly_unwrapped_optional
  var testSession: SKTestSession!

  @available(iOS 15.0, *)
  func getIAPTransactionForPurchaseResult(result: Product.PurchaseResult) throws -> IAPTransaction {
    switch result {
    case let .success(verificationResult):
      return verificationResult.iapTransaction
    default:
      throw StoreKitTestCaseError.purchaseFailed
    }
  }

  override func setUp() async throws {
    try await super.setUp()
    IAPTransactionCache.shared.reset()
    testSession = try SKTestSession(configurationFileNamed: Self.configFileName)
    testSession.resetToDefaultState()
    testSession.clearTransactions()
    testSession.disableDialogs = true
  }

  override func tearDown() {
    testSession = nil
    super.tearDown()
  }
}
