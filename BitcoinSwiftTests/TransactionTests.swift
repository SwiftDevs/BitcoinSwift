//
//  TransactionTests.swift
//  BitcoinSwift
//
//  Created by Kevin Greene on 9/27/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class TransactionTests: XCTestCase {

  let transactionBytes: [UInt8] = [
      0x01, 0x00, 0x00, 0x00,                           // version 1
      0x01,                                             // 1 input
      0x6d, 0xbd, 0xdb, 0x08, 0x5b, 0x1d, 0x8a, 0xf7,
      0x51, 0x84, 0xf0, 0xbc, 0x01, 0xfa, 0xd5, 0x8d,
      0x12, 0x66, 0xe9, 0xb6, 0x3b, 0x50, 0x88, 0x19,
      0x90, 0xe4, 0xb4, 0x0d, 0x6a, 0xee, 0x36, 0x29,
      0x00, 0x00, 0x00, 0x00,                           // previous output (outpoint)
      0x8b,                                             // script sig is 139 bytes long
      0x48, 0x30, 0x45, 0x02, 0x21, 0x00, 0xf3, 0x58,
      0x1e, 0x19, 0x72, 0xae, 0x8a, 0xc7, 0xc7, 0x36,
      0x7a, 0x7a, 0x25, 0x3b, 0xc1, 0x13, 0x52, 0x23,
      0xad, 0xb9, 0xa4, 0x68, 0xbb, 0x3a, 0x59, 0x23,
      0x3f, 0x45, 0xbc, 0x57, 0x83, 0x80, 0x02, 0x20,
      0x59, 0xaf, 0x01, 0xca, 0x17, 0xd0, 0x0e, 0x41,
      0x83, 0x7a, 0x1d, 0x58, 0xe9, 0x7a, 0xa3, 0x1b,
      0xae, 0x58, 0x4e, 0xde, 0xc2, 0x8d, 0x35, 0xbd,
      0x96, 0x92, 0x36, 0x90, 0x91, 0x3b, 0xae, 0x9a,
      0x01, 0x41, 0x04, 0x9c, 0x02, 0xbf, 0xc9, 0x7e,
      0xf2, 0x36, 0xce, 0x6d, 0x8f, 0xe5, 0xd9, 0x40,
      0x13, 0xc7, 0x21, 0xe9, 0x15, 0x98, 0x2a, 0xcd,
      0x2b, 0x12, 0xb6, 0x5d, 0x9b, 0x7d, 0x59, 0xe2,
      0x0a, 0x84, 0x20, 0x05, 0xf8, 0xfc, 0x4e, 0x02,
      0x53, 0x2e, 0x87, 0x3d, 0x37, 0xb9, 0x6f, 0x09,
      0xd6, 0xd4, 0x51, 0x1a, 0xda, 0x8f, 0x14, 0x04,
      0x2f, 0x46, 0x61, 0x4a, 0x4c, 0x70, 0xc0, 0xf1,
      0x4b, 0xef, 0xf5,                                 // script signature
      0xff, 0xff, 0xff, 0xff,                           // sequence
      0x02,                                             // 2 outputs
      0x40, 0x4b, 0x4c, 0x00, 0x00, 0x00, 0x00, 0x00,   // 0.05 BTC (5000000)
      0x19,                                             // script is 25 bytes long
      0x76, 0xa9, 0x14, 0x1a, 0xa0, 0xcd, 0x1c, 0xbe,
      0xa6, 0xe7, 0x45, 0x8a, 0x7a, 0xba, 0xd5, 0x12,
      0xa9, 0xd9, 0xea, 0x1a, 0xfb, 0x22, 0x5e, 0x88,
      0xac,                                             // script
      0x80, 0xfa, 0xe9, 0xc7, 0x00, 0x00, 0x00, 0x00,   // 33.54 BTC (3354000000)
      0x19,                                             // script is 25 bytes long
      0x76, 0xa9, 0x14, 0x0e, 0xab, 0x5b, 0xea, 0x43,
      0x6a, 0x04, 0x84, 0xcf, 0xab, 0x12, 0x48, 0x5e,
      0xfd, 0xa0, 0xb7, 0x8b, 0x4e, 0xcc, 0x52, 0x88,
      0xac,                                             // script
      0x00, 0x00, 0x00, 0x00]                           // lock time

  var transactionData: NSData!
  var transaction: Transaction!

  override func setUp() {
    transactionData = NSData(bytes: transactionBytes, length: transactionBytes.count)
    let outPointTxHashBytes: [UInt8] = [
        0x6d, 0xbd, 0xdb, 0x08, 0x5b, 0x1d, 0x8a, 0xf7,
        0x51, 0x84, 0xf0, 0xbc, 0x01, 0xfa, 0xd5, 0x8d,
        0x12, 0x66, 0xe9, 0xb6, 0x3b, 0x50, 0x88, 0x19,
        0x90, 0xe4, 0xb4, 0x0d, 0x6a, 0xee, 0x36, 0x29]
    let outPointTxHash = NSData(bytes: outPointTxHashBytes, length: outPointTxHashBytes.count)
    let outPoint = Transaction.OutPoint(transactionHash: outPointTxHash, index: 0)
    let scriptSignatureBytes: [UInt8] = [
        0x48, 0x30, 0x45, 0x02, 0x21, 0x00, 0xf3, 0x58,
        0x1e, 0x19, 0x72, 0xae, 0x8a, 0xc7, 0xc7, 0x36,
        0x7a, 0x7a, 0x25, 0x3b, 0xc1, 0x13, 0x52, 0x23,
        0xad, 0xb9, 0xa4, 0x68, 0xbb, 0x3a, 0x59, 0x23,
        0x3f, 0x45, 0xbc, 0x57, 0x83, 0x80, 0x02, 0x20,
        0x59, 0xaf, 0x01, 0xca, 0x17, 0xd0, 0x0e, 0x41,
        0x83, 0x7a, 0x1d, 0x58, 0xe9, 0x7a, 0xa3, 0x1b,
        0xae, 0x58, 0x4e, 0xde, 0xc2, 0x8d, 0x35, 0xbd,
        0x96, 0x92, 0x36, 0x90, 0x91, 0x3b, 0xae, 0x9a,
        0x01, 0x41, 0x04, 0x9c, 0x02, 0xbf, 0xc9, 0x7e,
        0xf2, 0x36, 0xce, 0x6d, 0x8f, 0xe5, 0xd9, 0x40,
        0x13, 0xc7, 0x21, 0xe9, 0x15, 0x98, 0x2a, 0xcd,
        0x2b, 0x12, 0xb6, 0x5d, 0x9b, 0x7d, 0x59, 0xe2,
        0x0a, 0x84, 0x20, 0x05, 0xf8, 0xfc, 0x4e, 0x02,
        0x53, 0x2e, 0x87, 0x3d, 0x37, 0xb9, 0x6f, 0x09,
        0xd6, 0xd4, 0x51, 0x1a, 0xda, 0x8f, 0x14, 0x04,
        0x2f, 0x46, 0x61, 0x4a, 0x4c, 0x70, 0xc0, 0xf1,
        0x4b, 0xef, 0xf5]
    let scriptSignature = NSData(bytes: scriptSignatureBytes, length: scriptSignatureBytes.count)
    let inputs = [
        Transaction.Input(outPoint: outPoint,
                          scriptSignature: scriptSignature,
                          sequence: 0xffffffff)]
    let output0ScriptBytes: [UInt8] = [
        0x76, 0xa9, 0x14, 0x1a, 0xa0, 0xcd, 0x1c, 0xbe,
        0xa6, 0xe7, 0x45, 0x8a, 0x7a, 0xba, 0xd5, 0x12,
        0xa9, 0xd9, 0xea, 0x1a, 0xfb, 0x22, 0x5e, 0x88,
        0xac]
    let output0Script = NSData(bytes: output0ScriptBytes, length: output0ScriptBytes.count)
    let output1ScriptBytes: [UInt8] = [
        0x76, 0xa9, 0x14, 0x0e, 0xab, 0x5b, 0xea, 0x43,
        0x6a, 0x04, 0x84, 0xcf, 0xab, 0x12, 0x48, 0x5e,
        0xfd, 0xa0, 0xb7, 0x8b, 0x4e, 0xcc, 0x52, 0x88,
        0xac]
    let output1Script = NSData(bytes: output1ScriptBytes, length: output1ScriptBytes.count)
    let outputs: [Transaction.Output] = [
        Transaction.Output(value: 5000000, script: output0Script),
        Transaction.Output(value: 3354000000, script: output1Script)]
    transaction = Transaction(version: UInt32(1),
                              inputs: inputs,
                              outputs: outputs,
                              lockTime: .AlwaysLocked)
  }

  func testTransactionEncoding() {
    XCTAssertEqual(transaction.bitcoinData, transactionData)
  }

  func testTransactionDecoding() {
    let stream = NSInputStream(data: transactionData)
    stream.open()
    if let testTransaction = Transaction.fromBitcoinStream(stream) {
      XCTAssertEqual(testTransaction, transaction)
    } else {
      XCTFail("Failed to parse Transaction")
    }
    XCTAssertFalse(stream.hasBytesAvailable)
    stream.close()
  }
}
