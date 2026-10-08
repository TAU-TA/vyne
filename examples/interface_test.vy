interface Point { x :: Float64, y :: Float64, }

pts :: Array<Point> = [Point(1.0, 2.0), Point(3.0, 4.0)];
out(pts[0].x);
out(pts[1].y);
out(pts[0].x + pts[1].y);