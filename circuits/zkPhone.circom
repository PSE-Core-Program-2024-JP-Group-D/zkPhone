pragma circom 2.0.0;
/*
    PJ for Hakathon at ETH Tokyo2024 
*/
include "circomlib/circuits/sha256/sha256.circom";

template VerifyPhone() {
    signal input phone_number[88];  // phone number in bit (XXX-XXXX-XXXX ;11bytes)
    signal input otp_code[32];      // one time pass-code (XXXX )
    signal input public_hash[256];       // hash is also calculated in advance
    signal sha_input[120];
    signal output calchash[256];

    // Users are required to submit phone number and otp separateley
    // phone number is public input to reveal their own numers.
    // this is up to use cases.

    // combine the numbers
    for (var i = 0; i< 88; i++){
        sha_input[i] <== phone_number[i];
    }
    for (var i =0; i< 32; i++){
        sha_input[88+i] <== otp_code[i];
    }

    // SHA256
    // we could also use Poseidon hash function but modules for iOS app was not found
    component hashPhoneSHA = Sha256(120); 
    hashPhoneSHA.in <== sha_input;

    for ( var i = 0; i< 256; i++){
        // constraints based on hash informtion
        hashPhoneSHA.out[i] === public_hash[i];
    }
    calchash <== hashPhoneSHA.out;
}

component main{public[phone_number]}  = VerifyPhone();