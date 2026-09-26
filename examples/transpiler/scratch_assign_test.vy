ruleset { dynamic_casting };

module vmath;
module vmem;

region probe {
    scratch a :: Float64[4];
    scratch b :: Float64[4];

    # initialize a
    a[0] = 1.0;
    a[1] = 2.0;
    a[2] = 3.0;
    a[3] = 4.0;

    # Case 1: scratch -> scratch, same shape
    b = a;
    out("case1: " + string(b[2]));         # 3.0

    # Case 2: typed array -> scratch
    arr :: Array = [10.0, 20.0, 30.0, 40.0];
    b = arr;
    out("case2: " + string(b[3]));         # 40.0

    # Case 3: boxed source (an untyped array here)
    mixed :: Array = [];
    mixed.push(5.0);
    mixed.push(6.0);
    mixed.push(7.0);
    mixed.push(8.0);
    b = mixed;
    out("case3: " + string(b[0]));         # 5.0
};