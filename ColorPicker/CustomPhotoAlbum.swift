//
//  CustomPhotoAlbum.swift
//  ColorPicker
//
//  Created by Andre Simon on 14-04-20.
//  Copyright © 2020 Andre Simon. All rights reserved.
//

import Foundation
import Photos
import UIKit


class CustomPhotoAlbum: NSObject {
    static let albumName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    static let shared = CustomPhotoAlbum()

    private var assetCollection: PHAssetCollection!

    private override init() {
        super.init()

        if let assetCollection = fetchAssetCollectionForAlbum() {
          self.assetCollection = assetCollection
          return
        }
    }

    private func checkAuthorizationWithHandler(completion: @escaping ((_ success: Bool, _ error: AlbumError?) -> Void)) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
          PHPhotoLibrary.requestAuthorization({ (status) in
            self.checkAuthorizationWithHandler(completion: completion)
          })
        }
        else if PHPhotoLibrary.authorizationStatus() == .authorized {
          self.createAlbumIfNeeded { (success, error) in
            if success {
                completion(true, nil)
            } else {
                completion(false, AlbumError.albumError)
            }

          }
        }
        else {
            completion(false, AlbumError.albumError)
        }
    }

    private func createAlbumIfNeeded(completion: @escaping ((_ success: Bool, _ error: AlbumError?) -> Void)) {
    if let assetCollection = fetchAssetCollectionForAlbum() {
      // Album already exists
      self.assetCollection = assetCollection
        completion(true, nil)
    } else {
      PHPhotoLibrary.shared().performChanges({
        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)   // create an asset collection with the album name
      }) { success, error in
        if success {
          self.assetCollection = self.fetchAssetCollectionForAlbum()
            completion(true, nil)
        } else {
          // Unable to create album
            completion(false, AlbumError.albumError)
        }
      }
    }
  }

  private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

    if let _: AnyObject = collection.firstObject {
      return collection.firstObject
    }
    return nil
  }
    
  func save(_ image: UIImage, completion: @escaping ((Bool, AlbumError?) -> ())) {
    self.checkAuthorizationWithHandler { (success, error) in
      if success, self.assetCollection != nil {
        PHPhotoLibrary.shared().performChanges({
          let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
          let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
          if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest.addAssets(enumeration)
          }
        }, completionHandler: { (success, error) in
            completion(success, AlbumError.albumError)
        })
      } else{
            completion(success, error)
        }
    }
  }
    
}
