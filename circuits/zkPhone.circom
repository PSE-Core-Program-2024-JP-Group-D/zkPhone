pragma circom 2.0.0;

include "circomlib/circuits/sha256/sha256.circom";
include "circomlib/circuits/bitify.circom";

template VerifyPhone() {
    signal input phone_number;  // phone number as a field element
    signal input otp_code;      // otp code as a field element
    signal input public_hash[256];  // hash is also calculated in advance
    signal output calchash[256];

    // Convert phone number to bits
    component phone2Bits = Num2Bits(64);  // 64 bits can represent up to 20 digits
    phone2Bits.in <== phone_number;

    // Convert otp code to bits
    component otp2Bits = Num2Bits(16);  // 16 bits can represent up to 4 digits
    otp2Bits.in <== otp_code;

    // Combine the bits
    signal sha_input[80];
    for (var i = 0; i < 64; i++) {
        sha_input[i] <== phone2Bits.out[i];
    }
    for (var i = 0; i < 16; i++) {
        sha_input[64 + i] <== otp2Bits.out[i];
    }

    // SHA256
    component hashPhoneSHA = Sha256(80); 
    hashPhoneSHA.in <== sha_input;

    for (var i = 0; i < 256; i++) {
        // constraints based on hash information
        hashPhoneSHA.out[i] === public_hash[i];
    }
    calchash <== hashPhoneSHA.out;
}

component main {public [phone_number]} = VerifyPhone();