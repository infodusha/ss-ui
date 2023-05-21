import Foundation

enum Cipher: String, Codable {
    case AEAD_AES_128_GCM = "AEAD_AES_128_GCM"
    case AEAD_AES_256_GCM = "AEAD_AES_256_GCM"
    case AEAD_CHACHA20_POLY1305 = "AEAD_CHACHA20_POLY1305"
}
