fn main() {
  x :: Int64 = 32;
  
  y :: Int64 = ~((~((x >> 3) << 3) + 1)) | 64; # y = 95
  
  z :: Int64 = (y ^ 15) & 112;                # z = 80
  
  if z == 80 {
    out ("Test passed");
  }
  else {
    out("Test failed");
  }
}
main();