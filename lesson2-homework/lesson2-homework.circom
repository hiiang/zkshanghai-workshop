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

template isZero () {
    signal input in;

    signal output out;

    signal inv <-- in != 0 ? 1/in : 0;

    out <== -in * inv + 1;
    in * out === 0;
}

template isEqual () {
    signal input in[2];

    signal output out;

    component isZ = isZero();
    isZ.in <== in[0] - in[1];
    out <== isZ.out;
}

template LessThan(n){
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);
    //n2b.in <== in[0] + 2 ** n - in[1];
    //out <== n2b.b[0];
    //不是很明白上面这种写法为什么会出现两个用于比较的数差值过大时，输出会错误的原因，后面慢慢排查吧
    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.b[n];
}

/*
template Selector(nChoices){
    signal input in[nChoices];
    signal input index;

    signal output out;

    out <== index < nChoices ? in[index] : 0;
}
*/

component main = LessThan(5);

/* INPUT = {
   "in" : ["16", "1"]
} */
