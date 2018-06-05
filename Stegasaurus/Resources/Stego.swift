////
////  Stego.swift
////  IQKeyboardManagerSwift
////
////  Created by Elliott Williams on 5/20/18.
////
//
//import Foundation
//
//class StegoUtils {
//
//    // UTILITIES!
//    // error domain
//let ISStegoErrorDomain = "ISStegoErrorDomain"
//    // cointaining string/substring
//    func Contains(string: String?, substring: String?) -> Bool {
//        if string != nil && substring != nil && !(Int((string as NSString?)?.range(of: substring ?? "", options: .caseInsensitive).length ?? 0) == 0) {
//            return true
//        }
//        return false
//    }
//
//    // substring
//    func Substring(string: String?, prefix: String?, suffix: String?) -> String? {
//        var substring: String? = nil
//        if string != nil {
//            let prefixRange: NSRange? = (string as NSString?)?.range(of: prefix ?? "")
//            if Int(prefixRange?.location ?? 0) != NSNotFound {
//                let suffixRange: NSRange? = (string as NSString?)?.range(of: suffix ?? "")
//                if Int(suffixRange?.location ?? 0) != NSNotFound {
//                    let range = NSRange(location: Int((prefixRange?.location ?? 0) + (prefixRange?.length ?? 0)), length: Int((suffixRange?.location ?? 0) - (prefixRange?.location ?? 0) - (prefixRange?.length ?? 0)))
//                    if Int(range.location) != NSNotFound {
//                        substring = (string as NSString?)?.substring(with: range)
//                    }
//                }
//            }
//        }
//        return substring
//    }
//
//    // error for domain of code
//    func ErrorForDomainCode(code: ISStegoErrorDomainCode) -> Error? {
//        var description = "not defined"
//        switch code {
//        case ISStegoErrorDomainCodeDataTooBig:
//            description = "The data is too big"
//        case ISStegoErrorDomainCodeImageTooSmall:
//            description = "Image is too small: must have at least \(MinPixels()) pixels"
//        case ISStegoErrorDomainCodeNoDataInImage:
//            description = "There is no data in image"
//        default:
//            break
//        }
//        let error = NSError(domain: ISStegoErrorDomain, code: Int(code), userInfo: [NSLocalizedDescriptionKey: description])
//        return error
//    }
//
//    // create image
//    func CGImageCreateWithImage(image: Any?) -> CGImageRef? {
//        var imageRef: CGImageRef? = nil
//        #if TARGET_OS_IPHONE
//        assert((image is UIImage), "image must be kind of UIImage")
//        imageRef = CGImageRef
//        CFRetain(image?.cgImage)
//        #else
//        assert((image is NSImage), "image must be kind of NSImage")
//        let data: Data? = image?.tiffRepresentation
//        let dataRef = CFBridgingRetain(data) as? CFDataRef?
//        let source = CGImageSourceCreateWithData(dataRef, nil)
//        imageRef = CGImageSourceCreateImageAtIndex(source, 0, nil)
//        #endif
//        return imageRef
//    }
//
//    // get image from CGImage
//    func Image(imageRef: CGImageRef?) -> Any? {
//        var image: Any? = nil
//        #if TARGET_OS_IPHONE
//        if let aRef = imageRef {
//            image = UIImage(cgImage: aRef)
//        }
//        #else
//        if let aRef = imageRef {
//            image = NSImage(cgImage: aRef, size: NSZeroSize)
//        }
//        #endif
//        return image
//    }
//
//} // end  UTILS class
//
//class StegoEncoder {
//
//        var currentShift: Int = 0
//        var currentCharacter: Int = 0
//        var step: UInt32 = 0
//        var currentDataToHide = ""
//
//    // convert
//    func stegoImage(forImage image: Any?, data: Any?) throws -> Any? {
//        assert((data is Data) || (data is String), "Invalid parameter not satisfying: (data is Data) || (data is String)")
//        assert(image != nil, "Invalid parameter not satisfying: image != nil")
//        let inputCGImage = CGImageCreateWithImage(image)
//        let width: Int = CGImageGetWidth(inputCGImage)
//        let height: Int = CGImageGetHeight(inputCGImage)
//        let size: Int = height * width
//        var pixels: [UInt32]
//        pixels = UInt32(calloc(size, MemoryLayout<UInt32>.size))
//        var processedImage: Any? = nil
//        if size >= MinPixels() {
//            let colorSpace = CGColorSpaceCreateDeviceRGB()
//            let context = CGContext(data: pixels, width: width, height: height, bitsPerComponent: BITS_PER_COMPONENT, bytesPerRow: BYTES_PER_PIXEL * width, space: colorSpace, bitmapInfo: [.premultipliedLast, .byteOrder32Big])
//            context.draw(in: inputCGImage, image: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
//            let success: Bool = try? hideData(data, inPixels: pixels, withSize: size)
//            if success {
//                let newCGImage = context.makeImage()
//                processedImage = Image(newCGImage)
//                CGImageRelease(newCGImage)
//            }
//            CGContextRelease(context)
//        } else {
//            if error != nil {
//                error = ErrorForDomainCode(ISStegoErrorDomainCodeImageTooSmall)
//            }
//        }
//        CGImageRelease(inputCGImage)
//        free(pixels)
//        return processedImage
//    }
//
//
//
//    // MARK: - Pixel operations
//    // hide data
//    func hideData(_ data: Any?, inPixels pixels: UnsafeMutablePointer<UInt32>?, withSize size: Int) throws {
//        var success = false
//        let messageToHide = message(toHide: data)
//        var dataLength = UInt32(messageToHide.count)
//        if dataLength <= INT_MAX && Int(dataLength * BITS_PER_COMPONENT) < size - SizeOfInfoLength() {
//            reset()
//            let data = Data(bytes: dataLength, length: BYTES_OF_LENGTH)
//            let lengthDataInfo = String(data: data, encoding: .ascii)
//            var pixelPosition: UInt32 = 0
//            currentDataToHide = lengthDataInfo
//            while pixelPosition < SizeOfInfoLength() {
//                pixels[pixelPosition] = newPixel(pixels[pixelPosition])
//                pixelPosition += 1
//            }
//            reset()
//            let pixelsToHide: Int = messageToHide.count * BITS_PER_COMPONENT
//            currentDataToHide = messageToHide
//            let ratio = Double((size - Int(pixelPosition)) / pixelsToHide)
//            let salt = Int(ratio)
//            while Int(pixelPosition) <= size {
//                pixels[pixelPosition] = newPixel(pixels[pixelPosition])
//                pixelPosition += UInt32(salt)
//            }
//            success = true
//        } else {
//            if error != nil {
//                error = ErrorForDomainCode(ISStegoErrorDomainCodeDataTooBig)
//            }
//        }
//        return success
//    }
//
//    func newPixel(_ pixel: UInt32) -> UInt32 {
//        let color: UInt32 = newColor(pixel)
//        step += 1
//        return color
//    }
//
//    func newColor(_ color: UInt32) -> UInt32 {
//        if currentDataToHide.length() > currentCharacter {
//            let asciiCode = UInt32(currentDataToHide[currentDataToHide.index(currentDataToHide.startIndex, offsetBy: currentCharacter)])
//            let shiftedBits: UInt32 = asciiCode >> currentShift
//            if currentShift == 0 {
//                currentShift = INITIAL_SHIFT
//                currentCharacter += 1
//            } else {
//                currentShift -= 1
//            }
//            return NewPixel(color, shiftedBits, ColorToStep(step))
//        }
//        return color
//    }
//
//    func reset() {
//        currentShift = INITIAL_SHIFT
//        currentCharacter = 0
//    }
//
//    // MARK: - Formatting data to hide
//    func message(toHide data: Any?) -> String? {
//        let base64 = self.base64(fromData: data)
//        return "\(DATA_PREFIX)\(base64 ?? "")\(DATA_SUFFIX)"
//    }
//
//    func base64(fromData data: Any?) -> String? {
//        var base64: String? = nil
//        if (data is String) {
//            let dataOfString: Data? = data?.data(using: .utf8)
//            base64 = dataOfString?.base64EncodedString(options: [])
//        } else {
//            base64 = data?.base64EncodedString(options: [])
//        }
//        return base64
//    }
//
//} // end encoder class
//
//class StegoDefaults {
//    let INITIAL_SHIFT: Int = 7
//    let BYTES_PER_PIXEL: Int = 4
//    let BITS_PER_COMPONENT: Int = 8
//    let BYTES_OF_LENGTH: Int = 4
//    let DATA_PREFIX = "<m>"
//    let DATA_SUFFIX = "</m>"
//
//    func SizeOfInfoLength() -> Int {
//        return BYTES_OF_LENGTH * BITS_PER_COMPONENT
//    }
//
//    func MinPixelsToMessage() -> Int {
//        return (DATA_PREFIX.count + DATA_SUFFIX.count) * BITS_PER_COMPONENT
//    }
//
//    func MinPixels() -> Int {
//        return SizeOfInfoLength() + MinPixelsToMessage()
//    }
//} // end stego defaults
//
//
//
//class ISStegoDecoder {
//    var currentShift: Int = 0
//    var bitsCharacter: Int = 0
//    var data = ""
//    var step: UInt32 = 0
//    var length: UInt32 = 0
//
//    func decodeStegoImage(_ image: Any?) throws -> Data? {
//        assert(image != nil, "Invalid parameter not satisfying: image != nil")
//        var data: Data? = nil
//        if hasData(inImage: image) {
//            let base64 = Substring(self.data, DATA_PREFIX, DATA_SUFFIX)
//            data = Data(base64Encoded: base64, options: [])
//        } else {
//            if error != nil {
//                error = ErrorForDomainCode(ISStegoErrorDomainCodeNoDataInImage)
//            }
//        }
//        return data
//    }
//
//    // data in image?
//    func hasData(inImage image: Any?) -> Bool {
//        let inputCGImage = CGImageCreateWithImage(image)
//        let width: Int = CGImageGetWidth(inputCGImage)
//        let height: Int = CGImageGetHeight(inputCGImage)
//        let size: Int = height * width
//        var pixels: [UInt32]
//        pixels = UInt32(calloc(size, MemoryLayout<UInt32>.size))
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: pixels, width: width, height: height, bitsPerComponent: BITS_PER_COMPONENT, bytesPerRow: BYTES_PER_PIXEL * width, space: colorSpace, bitmapInfo: [.premultipliedLast, .byteOrder32Big])
//        context.draw(in: inputCGImage, image: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
//        searchDatainPixels(pixels, withSize: size)
//        free(pixels)
//        CGContextRelease(context)
//        CGImageRelease(inputCGImage)
//        return hasData()
//    }
//
//    // MARK: - Pixel operations
//    func searchDatainPixels(_ pixels: UnsafeMutablePointer<UInt32>?, withSize size: Int) {
//        reset()
//        var pixelPosition: UInt32 = 0
//        while pixelPosition < SizeOfInfoLength() {
//            getDataWithPixel(pixels[pixelPosition])
//            pixelPosition += 1
//        }
//        reset()
//        let pixelsToHide: Int = length * BITS_PER_COMPONENT
//        let ratio = Double((size - Int(pixelPosition)) / pixelsToHide)
//        let salt = Int(ratio)
//        while Int(pixelPosition) <= size {
//            getDataWithPixel(pixels[pixelPosition])
//            pixelPosition += UInt32(salt)
//            if Contains(data, DATA_SUFFIX) {
//                break
//            }
//        }
//    }
//
//    func reset() {
//        currentShift = INITIAL_SHIFT
//        bitsCharacter = 0
//    }
//
//    func getDataWithPixel(_ pixel: UInt32) {
//        getDataWithColor(Color(pixel, ColorToStep(step)))
//    }
//
//    func getDataWithColor(_ color: UInt32) {
//        if currentShift == 0 {
//            let bit = UInt32(Int(color) & 1)
//            bitsCharacter = (bit << currentShift) | bitsCharacter
//            if step < SizeOfInfoLength() {
//                getLength()
//            } else {
//                getCharacter()
//            }
//            currentShift = INITIAL_SHIFT
//        } else {
//            let bit = UInt32(Int(color) & 1)
//            bitsCharacter = (bit << currentShift) | bitsCharacter
//            currentShift -= 1
//        }
//        step += 1
//    }
//
//    func getLength() {
//        length = AddBits(length, bitsCharacter, step % (BITS_PER_COMPONENT - 1))
//        bitsCharacter = 0
//    }
//
//    func getCharacter() {
//        let character = "\(UInt(bitsCharacter))"
//        bitsCharacter = 0
//        if data {
//            data = "\(data)\(character)"
//        } else {
//            data = character
//        }
//    }
//
//    // MARK: - Validation
//    func hasData() -> Bool {
//        return (data.length() > 0 && Contains(data, DATA_PREFIX) && Contains(data, DATA_SUFFIX)) ? true : false
//    }
//
//
//
//
//} // end Decoder class
//
//class Steganographer {
//    class func hideData(_ data: Any?, withImage image: Any?, completionBlock: ISStegoEncoderCompletionBlock) {
//        let queue = DispatchQueue(label: "steganography.encode.queue")
//        queue.async(execute: {() -> Void in
//            autoreleasepool {
//                var encoder = ISStegoEncoder()
//                var error: Error? = nil
//                let stegoImage = try? encoder.stegoImage(forImage: image, data: data)
//                completionBlock(stegoImage, error)
//                encoder = nil
//            }
//        })
//    }
//
//    convenience init(fromImage image: Any?, completionBlock: ISStegoDecoderCompletionBlock) {
//        let queue = DispatchQueue(label: "steganography.decode.queue")
//        queue.async(execute: {() -> Void in
//            autoreleasepool {
//                var error: Error? = nil
//                var decoder = ISStegoDecoder()
//                let data: Data? = try? decoder.decodeStegoImage(image)
//                completionBlock(data, error)
//                decoder = nil
//            }
//        })
//    }
//
//
//} // end steganographer class
//
//class PixelUtils {
//    func Mask8(x: UInt32) -> UInt32 {
//        return UInt32(Int(x) & 0xff)
//    }
//
//    func Color(x: UInt32, shift: Int) -> UInt32 {
//        return Mask8(Int(x) >> 8 * shift)
//    }
//
//    func AddBits(number1: UInt32, number2: UInt32, shift: Int) -> UInt32 {
//        return UInt32((Int(number1) | Int(Mask8(number2)) << 8 * shift))
//    }
//
//    func NewPixel(pixel: UInt32, shiftedBits: UInt32, shift: Int) -> UInt32 {
//        let bit = UInt32((Int(shiftedBits) & 1) << 8 * shift)
//        let colorAndNot = UInt32((Int(pixel) & ~(1 << 8 * shift)))
//        return colorAndNot | bit
//    }
//
//    func ColorToStep(step: UInt32) -> ISPixelColor {
//        if Int(step) % 3 == 0 {
//            return ISPixelColorBlue
//        } else if Int(step) % 2 == 0 {
//            return ISPixelColorGreen
//        } else {
//            return ISPixelColorRed
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
