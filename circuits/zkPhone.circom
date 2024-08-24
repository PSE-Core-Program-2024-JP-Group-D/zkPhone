pragma circom 2.0.0;

include "circomlib/circuits/sha256/sha256.circom";
include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";

template VerifyPhone() {
    signal input phone_number;  // phone number as a field element
    signal input otp_code;      // otp code as a field element
    signal input public_hash;   // hash as a single field element
    signal output is_valid;     // 1 if valid, 0 if not

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

    // Convert SHA256 output to a single field element
    component bits2Num = Bits2Num(256);
    for (var i = 0; i < 256; i++) {
        bits2Num.in[i] <== hashPhoneSHA.out[i];
    }

    // Compare calculated hash with public_hash
    component isEqual = IsEqual();
    isEqual.in[0] <== bits2Num.out;
    isEqual.in[1] <== public_hash;

    is_valid <== isEqual.out;
}

component main {public [phone_number, public_hash]} = VerifyPhone();