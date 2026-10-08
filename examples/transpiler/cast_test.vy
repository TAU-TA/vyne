through i :: 1..100 -> loop {
    b :: Array<Int64> = [1,2,3];
    b = [4,5,6];
};

through i :: 1..100 -> loop {
    @pool<Float64, 8> @speculative 
    region test {
        temp = pool_alloc();
        a :: Array<Int64> = [1,2,3];
        pool_free(tmp);
        a = [4,5,6];
        region.commit(true);
    };
};