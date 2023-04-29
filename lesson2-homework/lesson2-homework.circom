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
    // 如果 in[0] 等于 in[1]，则 out 应为 1。 否则，out 应该是 0
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

template Sum(n){
    signal input in[n];
    signal output out;
    signal sum[n + 1];

    sum[0] <== 0;
    for (var i = 0; i < n; i++) {
        sum[i + 1] <== in[i] + sum[i];
    }
    out <== sum[n];
}

template Selector(nChoices){
    signal input in[nChoices];
    signal input index;

    signal output out;

    // component les = LessThan(252);
    // les.in[0] <== index;
    // les.in[1] <== in[nChoices];

    component iseq[nChoices];
    component sum = Sum(nChoices);
    for (var i = 0; i < nChoices; i++) {
        // 把输入里的每个位置都和 index 对比来搜索 index 的位置
        // index 的位置是 1，index 没有的位置是 0（无论 index 是否在 nChoices 之内）
        iseq[i] = isEqual();
        iseq[i].in[0] <== i;
        iseq[i].in[1] <== index;
        
        // 当 index 小于 nChoices 的时候，iseq[index] = 1，此时乘以输入 in[index] 位置上的值，输出就是 in[index]
        sum.in[i] <== iseq[i].out * in[i]; 
    }

    out <== sum.out;
}


// 数学知识没补够有点理解不了题目，后续接着补上
// template IsNegative(){

// }

// template IntegerDivide(){

// }

component main = Selector(5);

/* INPUT = {
    "in": ["9", "13", "21", "35", "5"],
    "index": "4"
} */
