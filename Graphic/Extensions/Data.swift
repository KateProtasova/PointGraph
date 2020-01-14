//
//  Data.swift
//  Graphic
//
//  Created by Екатерина Протасова on 14.01.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import Foundation

extension Data {
   func getDocumentsDirectory() -> NSString {
          let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
          let documentsDirectory = paths[0]
          return documentsDirectory as NSString
      }

     func dataToFile(fileName: String) -> NSURL? {
         let data = self
         let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
         do {
             try data.write(to: URL(fileURLWithPath: filePath))
             return NSURL(fileURLWithPath: filePath)
         } catch {
             print("Error writing the file: \(error.localizedDescription)")
         }
         return nil
     }
 }
