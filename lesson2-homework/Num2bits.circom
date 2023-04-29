pragma circom 2.1.4;

template Num2Bits(nBits){
    signal input in;
    
    signal output b[nBits];

    var acc;

    for (var i = 0; i < nBits; i++) {
        b[i] <-- (in \ 2 ** i) % 2;
        0 === b[i] * (1 - b[i]);
        acc += b[i] * (2 ** i);
    }

    in === acc;
}


template Main(){
    signal input in;
    signal output o;

    component n2b = Num2Bits(5);
    n2b.in <== in;
    o <== n2b.b[0];
}

component main = Num2Bits(5);

/* INPUT = {
    "in" : "11"
} */
