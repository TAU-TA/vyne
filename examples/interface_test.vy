interface Point {
    x :: Float64,
    y :: Float64,
}

p :: Point = Point(1.5, 2.5);
out(p);
out(p.x);
out(p.y);
p = Point(3.5, 4.5);
out(p.x + p.y);