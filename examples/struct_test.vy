interface Point {
    x :: Float64;
    y :: Float64;
}

fn add_points(a :: Point, b :: Point) -> Point {
    return Point(a.x + b.x, a.y + b.y);
}

p1 :: Point = Point(1.0, 2.0);
p2 :: Point = Point(3.0, 4.0);
p3 :: Point = add_points(p1, p2);
out(p3.x);
out(p3.y);