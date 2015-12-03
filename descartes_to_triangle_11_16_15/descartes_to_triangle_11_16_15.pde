void setup() {
  float A = descartesToTriangle(1.3, 1.0)[0];
  println(A);
}

void draw(){
}

float descartesToTriangle(float x, float y) {
  float a = sqrt( sq(x) + sq(y - 1));
  float b = sqrt( sq( (-(sqrt(3))/2) - x) + sq(-0.5 - y) );
  float c = sqrt( sq( (sqrt(3)/2) - x) + sq(0.5 - y) );
  float[] res = { a,b,c };
  return res;
}