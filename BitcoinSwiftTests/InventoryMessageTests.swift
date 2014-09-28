//
//  InventoryMessageTests.swift
//  BitcoinSwift
//
//  Created by James MacWhyte on 8/23/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class InventoryMessageTests: XCTestCase {

  // TODO: Add edge test cases: Too many vectors, empty data, etc.

  func testInventoryMessageDecoding() {
    let bytes: [UInt8] = [
        0x01,                                           // Number of inventory vectors (1)
        0x02, 0x00, 0x00, 0x00,                         // First vector type (2: Block)
        0x71, 0x40, 0x03, 0x91, 0x50, 0x8c, 0xae, 0x45, // Block hash
        0x35, 0x86, 0x4f, 0x74, 0x91, 0x76, 0xab, 0x7f,
        0xa3, 0xa2, 0x51, 0xc2, 0x13, 0x40, 0x21, 0x1e,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    let data = NSData(bytes:bytes, length:bytes.count)
    if let inventoryMessage = InventoryMessage.fromData(data) {
      XCTAssertEqual(inventoryMessage.inventoryVectors.count, 1)
      let vector1Hash: [UInt8] = [
          0x71, 0x40, 0x03, 0x91, 0x50, 0x8c, 0xae, 0x45, // Block hash
          0x35, 0x86, 0x4f, 0x74, 0x91, 0x76, 0xab, 0x7f,
          0xa3, 0xa2, 0x51, 0xc2, 0x13, 0x40, 0x21, 0x1e,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
      let expectedInventoryVectors = [
          InventoryVector(type:InventoryVector.VectorType.Block,
                          hash:NSData(bytes:vector1Hash, length:vector1Hash.count))]
      XCTAssertEqual(inventoryMessage.inventoryVectors, expectedInventoryVectors)
    } else {
      XCTFail("\n[FAIL] Failed to parse InventoryMessage")
    }
  }

  func testInventoryMessageEncoding() {
    let vector1Hash: [UInt8] = [
        0x71, 0x40, 0x03, 0x91, 0x50, 0x8c, 0xae, 0x45, // Block hash
        0x35, 0x86, 0x4f, 0x74, 0x91, 0x76, 0xab, 0x7f,
        0xa3, 0xa2, 0x51, 0xc2, 0x13, 0x40, 0x21, 0x1e,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    let inventoryVectors = [
        InventoryVector(type:InventoryVector.VectorType.Block,
                        hash:NSData(bytes:vector1Hash, length:vector1Hash.count))]
    let inventoryMessage = InventoryMessage(inventoryVectors:inventoryVectors)
    let expectedBytes: [UInt8] = [
        0x01,                                           // Number of inventory vectors (1)
        0x02, 0x00, 0x00, 0x00,                         // First vector type (2: Block)
        0x71, 0x40, 0x03, 0x91, 0x50, 0x8c, 0xae, 0x45, // Block hash
        0x35, 0x86, 0x4f, 0x74, 0x91, 0x76, 0xab, 0x7f,
        0xa3, 0xa2, 0x51, 0xc2, 0x13, 0x40, 0x21, 0x1e,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    let expectedData = NSData(bytes:expectedBytes, length:expectedBytes.count)
    XCTAssertEqual(inventoryMessage.data, expectedData)
  }
}
