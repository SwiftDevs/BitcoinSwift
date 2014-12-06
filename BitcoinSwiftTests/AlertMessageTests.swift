//
//  AlertMessageTests.swift
//  BitcoinSwift
//
//  Created by Kevin Greene on 10/10/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class AlertMessageTests: XCTestCase {

  let alertMessageBytes: [UInt8] = [
      // Alert.
      0x73,                                             // Alert size: 115
      0x01, 0x00, 0x00, 0x00,                           // Version: 1
      0x37, 0x66, 0x40, 0x4f, 0x00, 0x00, 0x00, 0x00,   // RelayUntil: 1329620535
      0xb3, 0x05, 0x43, 0x4f, 0x00, 0x00, 0x00, 0x00,   // Expiration: 1329792435
      0xf2, 0x03, 0x00, 0x00,                           // ID: 1010
      0xf1, 0x03, 0x00, 0x00,                           // Cancel ID: 1009
      0x00,                                             // Cancel IDs: (empty)
      0x10, 0x27, 0x00, 0x00,                           // Minimum version: 10000
      0x48, 0xee, 0x00, 0x00,                           // Maximum version: 61000
      0x00,                                             // Affected user agents: (empty)
      0x64, 0x00, 0x00, 0x00,                           // Priority: 100
      0x00,                                             // Comment: (empty)
      0x46, 0x53, 0x65, 0x65, 0x20, 0x62, 0x69, 0x74,
      0x63, 0x6f, 0x69, 0x6e, 0x2e, 0x6f, 0x72, 0x67,
      0x2f, 0x66, 0x65, 0x62, 0x32, 0x30, 0x20, 0x69,
      0x66, 0x20, 0x79, 0x6f, 0x75, 0x20, 0x68, 0x61,
      0x76, 0x65, 0x20, 0x74, 0x72, 0x6f, 0x75, 0x62,
      0x6c, 0x65, 0x20, 0x63, 0x6f, 0x6e, 0x6e, 0x65,
      0x63, 0x74, 0x69, 0x6e, 0x67, 0x20, 0x61, 0x66,
      0x74, 0x65, 0x72, 0x20, 0x32, 0x30, 0x20, 0x46,
      0x65, 0x62, 0x72, 0x75, 0x61, 0x72, 0x79,
      // Message: "See bitcoin.org/feb20 if you have trouble connecting after 20 February"
      0x00,                                             // Reserved: (empty)
      0x47,                                             // Signature size: 71
      0x30, 0x45, 0x02, 0x21, 0x00, 0x83, 0x89, 0xdf,
      0x45, 0xf0, 0x70, 0x3f, 0x39, 0xec, 0x8c, 0x1c,
      0xc4, 0x2c, 0x13, 0x81, 0x0f, 0xfc, 0xae, 0x14,
      0x99, 0x5b, 0xb6, 0x48, 0x34, 0x02, 0x19, 0xe3,
      0x53, 0xb6, 0x3b, 0x53, 0xeb, 0x02, 0x20, 0x09,
      0xec, 0x65, 0xe1, 0xc1, 0xaa, 0xee, 0xc1, 0xfd,
      0x33, 0x4c, 0x6b, 0x68, 0x4b, 0xde, 0x2b, 0x3f,
      0x57, 0x30, 0x60, 0xd5, 0xb7, 0x0c, 0x3a, 0x46,
      0x72, 0x33, 0x26, 0xe4, 0xe8, 0xa4, 0xf1]         // Signature

  let signatureBytes: [UInt8] = [
      0x30, 0x45, 0x02, 0x21, 0x00, 0x83, 0x89, 0xdf,
      0x45, 0xf0, 0x70, 0x3f, 0x39, 0xec, 0x8c, 0x1c,
      0xc4, 0x2c, 0x13, 0x81, 0x0f, 0xfc, 0xae, 0x14,
      0x99, 0x5b, 0xb6, 0x48, 0x34, 0x02, 0x19, 0xe3,
      0x53, 0xb6, 0x3b, 0x53, 0xeb, 0x02, 0x20, 0x09,
      0xec, 0x65, 0xe1, 0xc1, 0xaa, 0xee, 0xc1, 0xfd,
      0x33, 0x4c, 0x6b, 0x68, 0x4b, 0xde, 0x2b, 0x3f,
      0x57, 0x30, 0x60, 0xd5, 0xb7, 0x0c, 0x3a, 0x46,
      0x72, 0x33, 0x26, 0xe4, 0xe8, 0xa4, 0xf1]

  var alertMessageData: NSData!
  var alertMessage: AlertMessage!

  override func setUp() {
    alertMessageData = NSData(bytes: alertMessageBytes, length: alertMessageBytes.count)
    let message = "See bitcoin.org/feb20 if you have trouble connecting after 20 February"
    let alert = Alert(version: 1,
                      relayUntilDate: NSDate(timeIntervalSince1970: 1329620535),
                      expirationDate: NSDate(timeIntervalSince1970: 1329792435),
                      ID: 1010,
                      cancelID: 1009,
                      cancelIDs: [],
                      minimumVersion: 10000,
                      maximumVersion: 61000,
                      affectedUserAgents: [],
                      priority: 100,
                      comment: "",
                      message: message,
                      reserved: "")
    let signature = NSData(bytes: signatureBytes, length: signatureBytes.count)
    alertMessage = AlertMessage(alert: alert, signature: signature)
  }

  func testAlertMessageEncoding() {
    XCTAssertEqual(alertMessage.bitcoinData, alertMessageData)
  }

  func testAlertMessageDecoding() {
    let stream = NSInputStream(data: alertMessageData)
    stream.open()
    if let testAlertMessage = AlertMessage.fromBitcoinStream(stream) {
      XCTAssertEqual(testAlertMessage, alertMessage)
    } else {
      XCTFail("Failed to parse AlertMessage")
    }
    XCTAssertFalse(stream.hasBytesAvailable)
    stream.close()
  }

  func testSignatureValidation() {
    // TODO
  }
}
