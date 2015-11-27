import UIKit
public enum Filtertype {
    case GreyScale
    case Sepia
    case Brightness(Float)      // use 0.2 to 5
    case Contrast(Float)        // use -128 to +128
    case TruncToWhite(Float)    // use 50 to 150
}

public class ImageFilter {
    var rgba: RGBAImage?
    
    public init(image: UIImage) {
        rgba = RGBAImage(image: image)!
    }
    
    public func applyFilter(filter: Filtertype){
        let width: Int = (rgba?.width)!
        let height: Int = (rgba?.height)!
        
        switch filter {
        case .GreyScale:
            // The formula for luminosity is 0.21 R + 0.72 G + 0.07 B.
            for y in 0..<height {
                for x in 0..<width {
                    
                    let index = y * width + x
                    var pix: Pixel = (rgba?.pixels[index])!
                    let red: Float = Float(pix.red) * 0.21
                    let green: Float = Float(pix.green) * 0.72
                    let blue: Float = Float(pix.blue) * 0.07
                    
                    let grey = Int( red + green + blue)
                    pix.red = UInt8(grey)
                    pix.green = UInt8(grey)
                    pix.blue = UInt8(grey)
                    
                    rgba?.pixels[index] = pix;
                }
            }
            
        case .Sepia:
            // The formula for Sepia is mor complex
            for y in 0..<height {
                for x in 0..<width {
                    let index = y * width + x
                    var pix: Pixel = (rgba?.pixels[index])!
                    
                    let r1: Float = Float(pix.red) * 0.393
                    let r2: Float = Float(pix.red) * 0.349
                    let r3: Float = Float(pix.red) * 0.272
                    
                    let g1: Float = Float(pix.green) * 0.769
                    let g2: Float = Float(pix.green) * 0.686
                    let g3: Float = Float(pix.green) * 0.168
                    
                    let b1: Float = Float(pix.blue) * 0.189
                    let b2: Float = Float(pix.blue) * 0.168
                    let b3: Float = Float(pix.blue) * 0.131
                    
                    pix.red = UInt8(max( min(255, r1 + g1 + b1), 0))
                    pix.green = UInt8(max( min(255, r2 + g2 + b2), 0))
                    pix.blue = UInt8(max( min(255, r3 + g3 + b3), 0))
                    
                    rgba?.pixels[index] = pix;
                }
            }
            
        case .Brightness(let value):
            // Formula is Color = Color * value
            for y in 0..<height {
                for x in 0..<width {
                    let index = y * width + x
                    var pix: Pixel = (rgba?.pixels[index])!
                    
                    pix.red = UInt8(max( min(255, Float(pix.red) * value), 0))
                    pix.green = UInt8(max( min(255, Float(pix.green) * value), 0))
                    pix.blue = UInt8(max( min(255, Float(pix.blue) * value), 0))
                    
                    rgba?.pixels[index] = pix;
                }
            }
            
            
            
        case .Contrast(let contrast):
            for y in 0..<height {
                for x in 0..<width {
                    let index = y * width + x
                    var pix: Pixel = (rgba?.pixels[index])!
                    let factor = (259 * (contrast + 255)) / (255 * (259 - contrast))
                    
                    pix.red = truncate(factor*(Float(pix.red) - 128) + 128)
                    pix.green = truncate(factor*(Float(pix.green) - 128) + 128)
                    pix.blue = truncate(factor*(Float(pix.blue) - 128) + 128)
                    rgba?.pixels[index] = pix;
                }
            }
            
        case .TruncToWhite(let value):
            for y in 0..<height {
                for x in 0..<width {
                    let index = y * width + x
                    var pix: Pixel = (rgba?.pixels[index])!
                    let middle = Int(Int(pix.red) + Int(pix.green) + Int(pix.blue)) / 3
                    if  Float(middle) > value {
                        pix.red = 255
                        pix.green = 255
                        pix.blue = 255
                        rgba?.pixels[index] = pix;
                    }
                }
            }
        }
    }
    
    public var image : UIImage? {
        return rgba?.toUIImage()
    }
    
    func truncate(value: Float) -> UInt8{
        return UInt8(max( min(255, value), 0))
    }
}
