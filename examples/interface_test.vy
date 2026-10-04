interface Point {
    x :: Float64,
    y :: Float64,
}

p :: Point = Point(1.5, 2.5);
out(p.x);          # 1.5
p.x = 10.5;
p.y = 20.5;
out(p.x);          # 10.5
out(p.y);          # 20.5
out(p.x + p.y);    # 31.0