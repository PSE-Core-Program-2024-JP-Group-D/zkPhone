const fs = require('fs');

// 文字列をビット列に変換し、配列形式にする関数
function stringToBinaryArray(str) {
    if (typeof str !== 'string') {
        console.error('Expected a string but got:', str);
        return [];
    }

    const binaryArray = str.split('').map(char => {
        return char.charCodeAt(0).toString(2).padStart(8, '0').split('');
    }).flat();

    return binaryArray;
}

// 16進数をビット列に変換し、配列形式にする関数
function hexToBinaryArray(hex) {
    if (typeof hex !== 'string') {
        console.error('Expected a string but got:', hex);
        return [];
    }

    // 0xがついている場合は取り除く
    hex = hex.replace(/^0x/, '');

    const binaryArray = hex.split('').map(char => {
        return parseInt(char, 16).toString(2).padStart(4, '0').split('');
    }).flat();

    return binaryArray;
}

// JSONファイルを読み込む
fs.readFile('originalinput.json', 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading file:', err);
        return;
    }

    try {
        // JSON文字列をオブジェクトに変換
        const jsonObj = JSON.parse(data);

        // ビット列を配列形式で変換
        const convertedJson = {
            phone_number: stringToBinaryArray(jsonObj.phone_number),
            otp_code: stringToBinaryArray(jsonObj.otp_code),
            public_hash: hexToBinaryArray(jsonObj.public_hash)
        };

        // 結果をinput.jsonとして保存
        fs.writeFile('input.json', JSON.stringify(convertedJson, null, 2), (err) => {
            if (err) {
                console.error('Error writing file:', err);
                return;
            }
            console.log('File successfully written as input.json');
        });
    } catch (parseError) {
        console.error('Error parsing JSON:', parseError);
    }
});
