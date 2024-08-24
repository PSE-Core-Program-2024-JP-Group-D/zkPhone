function hexToBinary(hex) {
    // Remove the "0x" if it's present
    hex = hex.replace(/^0x/, '');

    // Convert hex to binary string
    let binary = '';
    for (let i = 0; i < hex.length; i++) {
        // Convert each hex digit to a 4-bit binary string and concatenate
        binary += parseInt(hex[i], 16).toString(2).padStart(4, '0');
    }

    return binary;
}

// Example usage:
const hexValue = "a32300b16b6ad8d4012b3c022a36a6893b2c4ab83515d98dc6e21bd7adb76533";
const binaryString = hexToBinary(hexValue);
console.log(binaryString);  // Output: 0001101000111111
