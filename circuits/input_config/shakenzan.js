const crypto = require('crypto');

function stringToBitArray(str) {
    let bitArray = [];
    for (let i = 0; i < str.length; i++) {
        // 各文字をASCIIコードに変換
        let asciiCode = str.charCodeAt(i);

        // ASCIIコードを8ビットのバイナリに変換
        for (let j = 7; j >= 0; j--) {
            bitArray.push((asciiCode >> j) & 1);
        }
    }
    return bitArray;
}

function bitArrayToBuffer(bitArray) {
    let byteArray = [];
    for (let i = 0; i < bitArray.length; i += 8) {
        let byte = 0;
        for (let j = 0; j < 8; j++) {
            byte = (byte << 1) | bitArray[i + j];
        }
        byteArray.push(byte);
    }
    return Buffer.from(byteArray);
}

function calculateSha256Hash(str) {
    // 文字列をビット列に変換
    const bitArray = stringToBitArray(str);

    // ビット列をバイト配列（Buffer）に変換
    const buffer = bitArrayToBuffer(bitArray);

    // SHA-256ハッシュを計算
    const hash = crypto.createHash('sha256').update(buffer).digest('hex');

    return hash;
}

// "abc00000" のSHA-256ハッシュを計算する例
const inputString = "070135792461235";
const hash = calculateSha256Hash(inputString);

console.log("SHA-256 Hash:", hash);
