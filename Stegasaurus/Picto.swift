////
////  Picto.swift
////  Stegasaurus
////
////  Created by Elliott Williams on 4/28/18.
////  Copyright © 2018 AgrippaApps. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//import UIKit
//import RNCryptor
//
//
//class Picto {
//    static var pictographErrorDomain = "com.agrippa.Stegasaurus.ErrorDomain"
//
//    
//    let bitCountForCharacter = 8
//    let bitsChangedPerPixel = 2
//    let bitCountForInfo = 16
//    let bitCountForHiddenDataSize = 64
//    let bytesPerPixel = 4
//    let componentsPerPixel = 4
//    let maxIntFor8Bits = 255
//    let maxFloatFor8Bits = 255.0
//    let blueComponentIndex = 2
//    let extraImageShrinkingFactor: CGFloat = 2.0
//    
//    
//    
//    //Decodes a string from an image. Returns nil if there is no message in the image or if there was an error
//    func decode(_ image: PictographImage, encryptedWithPassword password: String, hiddenStringPointer hiddenString: String?, hiddenImagePointer hiddenImage: PictographImage?) throws {
//        var hiddenMessageData: Data?
//        var hiddenImageData: Data?
//        try? decodeData(in: image, encryptedWithPassword: password, hiddenMessageData: hiddenMessageData, hiddenImageData: hiddenImageData)
//        if hiddenMessageData != nil {
//            //In addition to converting the string back to a readable version, this converts any unicode scalars back to readable format (like emoji)
//            if let aData = hiddenMessageData {
//                hiddenString = String(data: aData, encoding: .nonLossyASCII)
//            }
//        }
//        if hiddenImageData != nil {
//            if let aData = hiddenImageData {
//                hiddenImage = PictographImage(base64Encoded: aData)
//            }
//        }
//    }
//    
//    
//    //Decodes UIImage image. Returns the encoded data in the image
//    //Password handler has no parameters and returns an NSString *
//    
//    func decodeData(in image: PictographImage, encryptedWithPassword password: String, hiddenMessageData: Data?, hiddenImageData: Data?) throws {
//        print("Decoding image with password %@", password)
//        var infoArrayInBits = [AnyHashable]()
//        //Getting information about the encoded message
//        let first8PixelsBlueComponents = getBlueComponents(from: image, atX: 0, andY: 0, count: pixelCount(forBit: bitCountForInfo))
//        for i in 0..<pixelCount(forBit: bitCountForInfo) {
//            //Going through each color that contains information about the message
//            addLastBits(fromBlueComponent: first8PixelsBlueComponents![i], toArray: infoArrayInBits)
//        }
//        free(first8PixelsBlueComponents)
//        let settingsBits: Int = long(fromBits: infoArrayInBits)
//        var messageIsEncrypted = false
//        /*
//         NOTE: See function definiton for determineSettingsBitsForMessageData to see how this works
//         */
//        
////        enum PictographEncodingOptions : Int {
////            case none = -1
////            case unencryptedMessage
////            case encryptedMessage
////            case unencryptedImage
////            case unencryptedMessageWithImage
////            case encryptedMessageWithImage
////        }
////
//        
//        switch settingsBits {
//        case PictographEncodingOptions.unencryptedMessage.rawValue:
//            messageIsEncrypted = false
//        case PictographEncodingOptions.encryptedMessage.rawValue:
//            messageIsEncrypted = true
//            if (password == "") {
//                //The message is encrypted and the user has no password entered, alert user
//                let userInfo = [NSLocalizedDescriptionKey: "The image you provided is encrypted and you didn't provide a password. Please enter the password."]
//                throw NSError(domain: Picto.pictographErrorDomain, code: PictographError.noPasswordProvidedError.rawValue, userInfo: userInfo)
//            }
//        case PictographEncodingOptions.unencryptedImage.rawValue:
//            break
//        case PictographEncodingOptions.unencryptedMessageWithImage.rawValue:
//            break
//        case PictographEncodingOptions.encryptedMessageWithImage.rawValue:
//            messageIsEncrypted = true
//            if (password == "") {
//                //The message is encrypted and the user has no password entered, alert user
//                let userInfo = [NSLocalizedDescriptionKey: "The image you provided is encrypted and you didn't provide a password. Please enter the password."]
//                throw NSError(domain: Picto.pictographErrorDomain, code: PictographError.noPasswordProvidedError.rawValue, userInfo: userInfo)
//            }
//        default:
//            //If there was an error, alert the user
//            let userInfo = [NSLocalizedDescriptionKey: "The image you provided does not contain a hidden message."]
//            throw NSError(domain: Picto.pictographErrorDomain, code: PictographError.noMessageInImageError.rawValue, userInfo: userInfo)
//            return
//        }
//        //Sending the analytics
////        PictographDataController.shared().analyticsDecodeSend(messageIsEncrypted)
//        //Message is not encrypted, send with blank password
//        try? data(from: image, needsPassword: messageIsEncrypted, password: password, hiddenMessageData: hiddenMessageData, hiddenImageData: hiddenImageData)
//    }
//    
//    
//    
//    func data(from image: PictographImage?, needsPassword isEncrypted: Bool, password: String?, hiddenMessageData: Data?, hiddenImageData: Data?) throws {
//        
//        //Getting the size of the string
//        var messageSizeArrayInBits = [AnyHashable]()
//        let blueComponentsContainingSizeOfMessage = getBlueComponents(from: image, atX: pixelCount(forBit: bitCountForInfo), andY: 0, count: pixelCount(forBit: bitCountForHiddenDataSize))
//        for i in 0..<pixelCount(forBit: bitCountForHiddenDataSize) {
//            //Going through each color that contains the size of the message
//            addLastBits(fromBlueComponent: blueComponentsContainingSizeOfMessage![i], toArray: messageSizeArrayInBits)
//        }
////        free(blueComponentsContainingSizeOfMessage)
//        let numberOfBitsNeededForMessage: Int = long(fromBits: messageSizeArrayInBits)
//        //Getting the size of any hidden image
//        var imageSizeArrayInBits = [AnyHashable]()
//        let blueComponentsContainingSizeOfImage = getBlueComponents(from: image, atX: pixelCount(forBit: bitCountForInfo + bitCountForHiddenDataSize), andY: 0, count: pixelCount(forBit: bitCountForHiddenDataSize))
//        for i in 0..<pixelCount(forBit: bitCountForHiddenDataSize) {
//            //Going through each color that contains the size of the message
//            addLastBits(fromBlueComponent: blueComponentsContainingSizeOfImage![i], toArray: imageSizeArrayInBits)
//        }
////        free(blueComponentsContainingSizeOfImage)
//        let numberOfBitsNeededForImage: Int = long(fromBits: imageSizeArrayInBits)
//        if numberOfBitsNeededForMessage > 0 {
//            hiddenMessageData = try? getDataFromPixles(withBitCountOffset: 0, from: image!, numberOfBitsToGet: numberOfBitsNeededForMessage, totalBitsForLogging: (numberOfBitsNeededForMessage + numberOfBitsNeededForImage), isEncrypted: isEncrypted, withPassword: password!, isMessage: true)
//        }
//        if numberOfBitsNeededForImage > 0 && error == nil {
//            hiddenImageData = try? getDataFromPixles(withBitCountOffset: numberOfBitsNeededForMessage, from: image, numberOfBitsToGet: numberOfBitsNeededForImage, totalBitsForLogging: (numberOfBitsNeededForMessage + numberOfBitsNeededForImage), isEncrypted: isEncrypted, withPassword: password, isMessage: false)
//        }
////        //Sending the analytics
////        PictographDataController.shared().analyticsDecodeSend(isEncrypted)
//    }
//    
//    
//    //This goes through a range of pixels and transforms the last two bits from each blue value into a usable NSData reference. Makes the delegate call for logging
//    
//    func getDataFromPixles(withBitCountOffset bitCountOffset: Int, from image: PictographImage, numberOfBitsToGet: Int, totalBitsForLogging totalBitCount: Int, isEncrypted: Bool, withPassword password: String, isMessage: Bool) throws -> Data? {
//        //Going through all the pixels to get the char value
//        var arrayOfBitsForMessage = [AnyHashable]()
//        var dataFromImage = Data()
//        var toReturn: Data?
//        let firstPixelWithHiddenData: Int = self.pixelCount(forBit: (bitCountForInfo + bitCountForHiddenDataSize + bitCountForHiddenDataSize + bitCountOffset))
//        let arrayOfBlueComponents = getBlueComponents(from: image, atX: firstPixelWithHiddenData, andY: 0, count: self.pixelCount(forBit: numberOfBitsToGet))
//        let pixelCount: Int = self.pixelCount(forBit: totalBitCount)
//        let startingPixelCount: Int = self.pixelCount(forBit: bitCountOffset)
//        let oneHundredthStep = Int(fmax(Float(pixelCount / 100), 1))
//        //To determine percentage
//        for i in 0..<self.pixelCount(forBit: numberOfBitsToGet) {
//            if isCancelled() {
//                //Break out of loop
//                break
//            }
//            //Going through each pixel
//            let blueComponent: UInt8 = arrayOfBlueComponents![i]
//            addLastBits(fromBlueComponent: blueComponent, toArray: arrayOfBitsForMessage)
//            print("Reading pixel value at index %i", i)
//            if i % oneHundredthStep == 0 && delegate != nil {
//                let percentDone = Float((i + startingPixelCount)) / Float(pixelCount)
//                delegate().pictographImageCoderDidUpdateProgress(percentDone)
//            }
//            if arrayOfBitsForMessage.count == bitCountForCharacter {
//                //If there are now enough bits to make a char
//                let longChar: Int = long(fromBits: arrayOfBitsForMessage)
//                var curChar = Int8(longChar)
//                dataFromImage.append(curChar, count: 1)
//                arrayOfBitsForMessage.removeAll()
//                //Reset the array for the next char
//            }
//        }
//        free(arrayOfBlueComponents)
//        if isEncrypted && isMessage {
//            //If message is encrypted, decrypt it and save it
//            var decryptError: Error? = nil
//            toReturn = try RNCryptor.decrypt(data: dataFromImage, withPassword: password)
//            if decryptError != nil {
//                //If there was an error, alert the user
//                let userInfo = [NSLocalizedDescriptionKey: "The password you entered was incorrect. Please try again."]
//                throw NSError(domain: Picto.pictographErrorDomain, code: PictographError.passwordIncorrectError.rawValue, userInfo: userInfo)
//                return nil
//            }
//        } else {
//            toReturn = dataFromImage
//        }
//        return toReturn
//    }
//    
//    //=======
//    //Adds the last 2 bits of the blue value from PictographColor color to the NSMutableArray array
//    
//    func addLastBits(fromBlueComponent blueComponent: UInt8, toArray array: [AnyHashable]?) {
//        let arrayOfBitsFromBlue = binaryString(fromInteger: Int(blueComponent), withSpaceFor: bitCountForCharacter)
//        array?.append(arrayOfBitsFromBlue[6])
//        array?.append(arrayOfBitsFromBlue[7])
//    }
//    
//    // MARK: Encoding messages and images
//    //Encodes UIImage image with message message. Returns the modified UIImage or NSImage
//    func encodeMessage(_ message: String?, hiddenImage: PictographImage?, shrinkImageMore: Bool, in image: PictographImage, encryptedWithPassword password: String) throws -> Data? {
//        print("Encoding message: %@, with password %@", message, password)
//        var unicodeMessageData: Data?
//        var dataFromImageToHide: Data?
//        if message != nil && !(message == "") {
//            //Converting emoji to the unicode scalars
//            unicodeMessageData = message?.data(using: .nonLossyASCII)
//        }
//        if hiddenImage != nil {
//            // not rotating image, references an input which isn't allowed in swift... not important to fix yet but refer to pictographimage for the rotateUIImage code (commented out)
////            hiddenImage = rotatedUIImage(from: hiddenImage)
//            let originalSize = CGSize(width: hiddenImage?.getReconciledImageWidth() ?? Int(0.0), height: hiddenImage?.getReconciledImageHeight() ?? Int(0.0))
//            let newSize: CGSize = determineSize(forHiding: hiddenImage, within: image, shrinkImageMore: shrinkImageMore)
//            var imageToHide: PictographImage? = hiddenImage
//            if originalSize.width != newSize.width && originalSize.height != newSize.height {
//                //If the hidden image needs to be resized
//                print("Hidden image needs to be this size, resizing: width: %f, height: %f", newSize.width, newSize.height)
//                imageToHide = imageToHide?.scaledImage(withNewSize: newSize)
//            }
//            dataFromImageToHide = imageToHide?.dataRepresentation()
//        }
//        return try! encodeMessageData(unicodeMessageData!, imageData: dataFromImageToHide, in: image, encryptedWithPassword: password)
//    }
//    
//    
//    
//    
//    
//    
//    //MARK:- Missing some of it's commentary :)
//    func encodeMessageData(_ messageData: Data, imageData: Data?, in image: PictographImage, encryptedWithPassword password: String) throws -> Data? {
//        var messageDataToEncode: Data?
//        let isEncrypted: Bool = !(password == "")
//        let thereIsMessageData: Bool = !(messageData.count > 0)
//        
//        if isEncrypted && thereIsMessageData {
//            //If the user wants to encrypt the string, encrypt it
//            // import RNCryptor via PODS
//            messageDataToEncode = try RNCryptor.encrypt(data: messageData, withPassword: password)
//            //^^^^^^^kRNCryptorAES256Settings???????????????????????????
////                RNEncryptor.encryptData(messageData, withSettings: kRNCryptorAES256Settings, password: password)
//            
//            let userInfo = [NSLocalizedDescriptionKey: "Something went wrong, probably an encryption failure. Adjust and try again."]
//            throw NSError(domain: Picto.pictographErrorDomain, code: PictographError.noMessageInImageError.rawValue, userInfo: userInfo)
////            if error != nil {
////                return nil
////            }
//            
//        } else if messageData != nil {
//            //No need to encrypt
//            messageDataToEncode = messageData
//        } else if isEncrypted {
//            let userInfo = [NSLocalizedDescriptionKey: "A password was used but no message was sent. A message is needed if encryption is enabled."]
//            throw NSError(domain: Picto.pictographErrorDomain, code: PictographError.noPasswordProvidedError.rawValue, userInfo: userInfo)
//        }
//        var bitsNeededForMessageData: Int = 0
//        if messageDataToEncode != nil {
//            bitsNeededForMessageData = (messageDataToEncode?.count ?? 0) * bitCountForCharacter
//        }
//        var bitsNeededForImageData: Int = 0
//        if imageData != nil {
//            bitsNeededForImageData = (imageData?.count ?? 0) * bitCountForCharacter
//        }
//        let bitsNeededForAllData: Int = bitsNeededForMessageData + bitsNeededForImageData
//        let numberOfPixelsNeeded: Int = pixelCount(forBit: (bitCountForInfo + bitCountForHiddenDataSize + bitCountForHiddenDataSize + bitsNeededForAllData))
//        if (image.getReconciledImageHeight() * image.getReconciledImageWidth()) <= numberOfPixelsNeeded {
//            let userInfo = [NSLocalizedDescriptionKey: "Image was too small, please select a larger image."]
//            throw NSError(domain: Picto.pictographErrorDomain, code: PictographError.imageTooSmallError.rawValue, userInfo: userInfo)
//            print("error image too small error")
//
//            return nil
//        }
//        var arrayOfBits = [AnyHashable]()
//        let settingsBit: Int = determineSettingsBits(forMessageData: messageDataToEncode, imageData: imageData, isEncrypted: isEncrypted)
//        arrayOfBits.append(binaryString(fromInteger: settingsBit, withSpaceFor: bitCountForInfo) as! AnyHashable)
//        //16 bits for future proofing
//        arrayOfBits.append(binaryString(fromInteger: bitsNeededForMessageData, withSpaceFor: bitCountForHiddenDataSize) as! AnyHashable)
//        //64 bits for message size
//        arrayOfBits.append(binaryString(fromInteger: bitsNeededForImageData, withSpaceFor: bitCountForHiddenDataSize) as! AnyHashable)
//        //64 bits for image size
//        var arrayOfDataToEncode = [AnyHashable]()
//        if messageDataToEncode != nil {
//            if let anEncode = messageDataToEncode {
//                arrayOfDataToEncode.append(anEncode)
//            }
//        }
//        if imageData != nil {
//            if let aData = imageData {
//                arrayOfDataToEncode.append(aData)
//            }
//        }
//        for data: Data in arrayOfDataToEncode as? [Data] ?? [Data]() {
//            let dataN = data as NSData
//            let bytes = dataN.bytes
//            for charIndex in 0..<data.count {
//                let curChar = Int8(bytes[charIndex])
//                arrayOfBits.append(contentsOf: binaryString(fromInteger: curChar, withSpaceFor: bitCountForCharacter))
//                //Only 8 bits needed for chars
//            }
//        }
//        return saveImageToGraphicsContextAndEncodeBits(in: image, arrayOfBits: arrayOfBits)
//    }
//    
//    
//    
//    //Saves the image to the graphics context and starts encoding the bits in that image
//    
//    func saveImageToGraphicsContextAndEncodeBits(in image: PictographImage?, arrayOfBits: [AnyHashable]?) -> Data? {
//        //Right here we have all the bits that are needed to encode the data in the image
//        guard let imaged = image else {
//            print("no image here... save image to graphics context and encode bits it didn't work ")
//            return nil
//        }
//
//        #if TARGET_OS_IPHONE
//        image = rotatedUIImage(from: image)
//        #endif
//        let imageWidth: Int? = image?.getReconciledImageWidth()
//        let imageHeight: Int? = image?.getReconciledImageHeight()
//        let colorspace = CGColorSpaceCreateDeviceRGB()
//        let bitsPerComponent: size_t = 8
//        let bytesPerRow: size_t = bytesPerPixel * (imageWidth ?? 0)
//        let pixelBuffer = pixelBufferWithBlueComponentsChanged(from: image, arrayOfBits: arrayOfBits)
//        let editedBitmap = CGContext(data: pixelBuffer, width: imageWidth!, height: imageHeight!, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorspace, bitmapInfo: CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.first.rawValue).rawValue)
//        //|| .byteOrder32Little.rawValue) ======    || CGBitmapInfo.alphaInfoMask.premultipliedLast
//        //Getting the image from the bitmap
//        var dataRepresentationOfModifiedImage: Data?
//        let outputImage = editedBitmap?.makeImage()
//        //CGImageRef to NSData
//        let encodedImage = UIImage(cgImage: outputImage!)
//        dataRepresentationOfModifiedImage = UIImagePNGRepresentation(encodedImage)
//        //Freeing the memory
//        return dataRepresentationOfModifiedImage
//    }
//    
//    
//    
//    func pixelBufferWithBlueComponentsChanged(from image: PictographImage?, arrayOfBits: [AnyHashable]?) -> UnsafeMutablePointer<UInt8>? {
//        let pixelBuffer = getRawPixelData(for: image)
//        let numberOfPixelsNeeded = pixelCount(forBit: Int(arrayOfBits?.count))
//        var encodeCounter: Int = 0
//        //Counter which bit we are encoding, goes up 2 with each pixel
//        let oneHundredthStep = Int(fmax(Float(numberOfPixelsNeeded / 100), 1))
//        //To determine percentage
//        //Need numberOfPixelsNeeded * 4 due to this array counting by components of each pixel (RGBA)
//        var i = 0
//        while i < (numberOfPixelsNeeded * 4) {
//            if isCancelled() {
//                //Break out of loop
//                break
//            }
//            //Get the current blue value, change out the last bits, and then put the new value in the buffer again
//            let currentBlueValue: UInt8 = pixelBuffer![i + blueComponentIndex]
//            let newBlueValue: UInt8 = newBlueComponentValue(from: currentBlueValue, encodeCounter: encodeCounter, arrayOfBits: arrayOfBits)
//            pixelBuffer![i + blueComponentIndex] = newBlueValue
//            print("Changing pixel value at index %i", (i / 4))
//            if (i / 4) % oneHundredthStep == 0 && delegate != nil {
//                let percentDone = i / Float(numberOfPixelsNeeded * 4)
//                delegate().pictographImageCoderDidUpdateProgress(percentDone)
//            }
//            encodeCounter += 2
//            i += 4
//        }
//        return pixelBuffer
//    }
//    
//    
//    
//    //Gets the color that the specified pixel should be
//    func newBlueComponentValue(from currentBlueComponent: UInt8, encodeCounter: Int, arrayOfBits: [Any]?) -> UInt8 {
//        //Changing the value of the blue byte
//        var arrayOfBitsFromBlue = binaryString(fromInteger: Int(currentBlueComponent), withSpaceFor: bitCountForCharacter)
//        //Changing the least significant bits of the blue byte
//        arrayOfBitsFromBlue![6] = arrayOfBits![encodeCounter]
//        arrayOfBitsFromBlue![7] = arrayOfBits![encodeCounter + 1]
//        let newBlueLong: Int = long(fromBits: arrayOfBitsFromBlue)
//        return UInt8(UInt(newBlueLong))
//    }
//    
//    // MARK: Helper methods used for hiding an image within another image
//    #if TARGET_OS_IPHONE
//    /**
//     UIImages taken with the iPhone camera have an orientation of right even though they are straight up. This causes the image to be distored when restored from the bitmap. This corrects the image orientation.
//     @param image image to rotate
//     @return rotated image
//     */
//    func rotatedUIImage(from image: UIImage?) -> UIImage? {
//        let imageWidth: Int? = image?.getReconciledImageWidth()
//        let imageHeight: Int? = image?.getReconciledImageHeight()
//        UIGraphicsBeginImageContext(CGSize(width: CGFloat(imageWidth ?? 0.0), height: CGFloat(imageHeight ?? 0.0)))
//        image?.draw(at: CGPoint(x: 0, y: 0))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }
//    
//    #endif
//    
//    
//    /**
//    Determines the size that the hidden image will need to be in order to fit in the original image. Instead of figuring out the exact size that will make the image fit, it cuts the scale factor in half each time. Starting with 1, then 1/2, then 1/4 etc
//    
//    @param hiddenImage image to hide
//    @param image image that the hiddenImage will be hidden in
//    @param shrinkImageMore if true, shrinks image by extra factor for faster encoding
//    @return factor that hiddenImage needs to be scaled by
//    */
//    
//    func determineSize(forHiding hiddenImage: PictographImage?, within image: PictographImage?, shrinkImageMore: Bool) -> CGSize {
//        
//        guard let hiddenPic = hiddenImage else {
//            print("no hidden image here... determining it didn't work ")
//            return CGSize(width: 0.0, height: 0.0)
//        }
//        guard let pic = image else {
//            print("no image here... determining it didn't work ")
//            return CGSize(width: 0.0, height: 0.0)
//        }
//        print("seems pic and hidden pic both exist (guards complete)")
//
//        
//        let numberOfPixelsInMainImage: Int = image!.getReconciledImageWidth() * image!.getReconciledImageHeight()
//        var scaleFactor: CGFloat = 1
//        var hiddenImageSize = CGSize(width: hiddenImage?.getReconciledImageWidth() ?? Int(0.0 * scaleFactor), height: hiddenImage?.getReconciledImageHeight() ?? Int(0.0 * scaleFactor))
//        var pixelsNeededForHiddenImage: Int = numberOfPixelsNeeded(toHideImageOf: hiddenImageSize)
//        while pixelsNeededForHiddenImage >= numberOfPixelsInMainImage {
//            //Cut the width and height of the image in half each time
//            scaleFactor = scaleFactor / 2
//            hiddenImageSize = CGSize(width: hiddenImage?.getReconciledImageWidth() ?? Int(0.0 * scaleFactor), height: hiddenImage?.getReconciledImageHeight() ?? Int(0.0 * scaleFactor))
//            pixelsNeededForHiddenImage = numberOfPixelsNeeded(toHideImageOf: hiddenImageSize)
//        }
//        if shrinkImageMore {
//            //Scale the image down again if the user wants faster encoding
//            print("shrinking more")
//            scaleFactor = scaleFactor / extraImageShrinkingFactor
//            hiddenImageSize = CGSize(width: hiddenImage?.getReconciledImageWidth() ?? Int(0.0 * scaleFactor), height: hiddenImage?.getReconciledImageHeight() ?? Int(0.0 * scaleFactor))
//        }
//        return hiddenImageSize
//    }
//
//    /**
//     This is the number of pixels that it would take to hide the specified image, including the information bits about the image
//     
//     @param imageSize size of the image not counting retina displays
//     @return number of pixels it would take to encode all information
//     */
//    
//    func numberOfPixelsNeeded(toHideImageOf imageSize: CGSize) -> Int {
//        //Number of bits needed to encode a single pixel worth of information
//        let bitsNeededPerPixel: Int = bitCountForCharacter * bytesPerPixel
//        let bitsNeededToEncodeEntireImage = Int(CGFloat(bitsNeededPerPixel) * imageSize.width * imageSize.height)
//        //16 bits for info about image, 64 bits for number of bits needed
//        let totalBitsToEncode: Int = bitCountForInfo + bitCountForHiddenDataSize + bitCountForHiddenDataSize + bitsNeededToEncodeEntireImage
//        return totalBitsToEncode / bitsChangedPerPixel
//    }
//
//    // MARK: Methods used for both encoding and decoding
//    /* Returns the binary representation of a character */
//    //http://stackoverflow.com/questions/655792/how-to-convert-nsinteger-to-a-binary-string-value
//    //Used the above link as information, but instead decided to use an int array and remove spacing
//    func binaryString(fromInteger number: Int, withSpaceFor numberOfBits: Int) -> [Any]? {
//        var bitArray = [AnyHashable]()
//        var binaryDigit: Int = 0
//        var integer: Int = number
//        while binaryDigit < numberOfBits {
//            //Going through each binary digit
//            binaryDigit += 1
//            bitArray.insert((integer & 1) != 0 ? 1 : 0, at: 0)
//            integer = integer >> 1
//        }
//        return bitArray
//    }
//    
//    /* Returns the long representation of a bit array
//     For example (["1", "1", "0", "1"] -> 13) */
//    func long(fromBits bitArray: [Any]?) -> Int {
//        var singleCharacterArrayInBits = String()
//        for singleCharCounter in 0..<(bitArray?.count ?? 0) {
//            //Creating a string of the bits that make up this one character, this is easily convertible to a char
//            if let aCounter = bitArray?[singleCharCounter] {
//                singleCharacterArrayInBits += "\(aCounter)"
//            }
//        }
//        let longRep: Int = strtol(Int8(singleCharacterArrayInBits.utf8CString), nil, 2)
//        return longRep
//    }
//
//    
//    
//    /* Returns an array of PictographColors for the pixels starting at x, y for count number of pixels
//     http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
//     Used the above link as inspiration, but heavily modified */
//    
//    func getBlueComponents(from image: PictographImage?, atX x: Int, andY y: Int, count: Int) -> UnsafeMutablePointer<UInt8>? {
//        //Getting the raw data
//        let rawData = getRawPixelData(for: image)
//        let blueComponentArray: UnsafeMutablePointer<UInt8>?
////        malloc(count, *, sizeof, (, unsigned, char)
//        let width: Int? = image?.getReconciledImageWidth()
//        let bytesPerRow: Int = bytesPerPixel * (width ?? 0)
//        var byteIndex: Int = (bytesPerRow * y) + x * bytesPerPixel
//        for counter in 0..<count {
//            //Getting the bits for each color space red, green, blue, and alpha
//            let blueComponent: UInt8 = rawData![byteIndex + 2]
//            blueComponentArray![counter] = blueComponent
//            // THIS OPTIONAL CAN CRASH AND SHOULD BE ADDRESSED
//            byteIndex += bytesPerPixel
//        }
//        free(rawData)
//        return blueComponentArray
//    }
//    
//    /* Returns the raw pixel data for a UIImage image */
//    //This returns a (void *) of the pixel data from this image. By casting it as an array of unsigned char, we can easily access the RGBA values of each pixel. This also makes it easy to iterate over the entire image as well.
//    //  (assuming i % 4 == 0)
//    //  pixelBuffer[i] is the red
//    //  pixelBuffer[i+1] is the green
//    //  pixelBuffer[i+2] is the blue
//    //  pixelBuffer[i+3] is the alpha
//    
//    func getRawPixelData(for image: PictographImage?) -> UnsafeMutablePointer<UInt8>? {
//        guard let pic =  image else {
//            print("No image to get raw pixel data from")
//            return nil
//        }
//        // First get the image into your data buffer
//        let imageRef = image!.getReconciledCGImageRef()
//        let width: Int = image?.getReconciledImageWidth() ?? 0 // crash risk
//        let height: Int = image?.getReconciledImageHeight() ?? 0
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let rawData: UnsafeMutablePointer<UInt8>?
////        malloc(height, *, width, *, componentsPerPixel, *, sizeof, (, unsigned, char)
//        let bytesPerRow: Int = bytesPerPixel * (width)
//        let bitsPerComponent: Int = 8
//        let context = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.first.rawValue).rawValue)
////        context.draw(in: imageRef, image: CGRect(x: 0, y: 0, width: CGFloat(width ?? 0), height: CGFloat(height ?? 0))) // replaced by below
//        context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
//
//        //Freeing the memory
//        return rawData
//    }
//    
//    
//    /**
//     Pictograph uses a 16 bit settings number to determine how to encrypt/decrypt a message
//     
//     (0) 00000000 00000000 - Unencrypted message
//     (1) 00000000 00000001 - Encrypted message
//     (2) 00000000 00000010 - Unencrypted image
//     (3) 00000000 00000011 - Unencrypted message with hidden image
//     (4) 00000000 00000100 - Encrypted message with hidden image
//     
//     @param messageData message data if any is being encoded
//     @param imageData image data if any is being encoded
//     @param isEncrypted if message should be encrypted
//     @return correct settings bit
//     */
//    
//    func determineSettingsBits(forMessageData messageData: Data?, imageData: Data?, isEncrypted: Bool) -> Int {
//        var bit: Int = -1
//        if messageData != nil {
//            bit += 1
//            if isEncrypted {
//                bit += 1
//            }
//        }
//        if imageData != nil {
//            bit += 3
//        }
//        return bit
//    }
//
//    // MARK: Dealing with bits
//    /**
//     Returns the corresponding pixel for the specified bit
//     
//     @param bit bit number that we're looking at
//     @return pixel that count be changed
//     */
//    func pixelCount(forBit bit: Int) -> Int {
//        return bit / bitsChangedPerPixel
//    }
//
//    
//
//    
//    
//    
//    
//    
//    
//}// end picto
//
//enum PictographError : Int {
//    case imageTooSmallError
//    case passwordIncorrectError
//    case noPasswordProvidedError
//    case noMessageInImageError
//}
