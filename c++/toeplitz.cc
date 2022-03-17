// toeplitz - tool for transformation of data using matrix multiplication of blocks of bits
// Rok Zitko, March 2022

#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector>
#include <cassert>
#include <bitset>
#include <string>
#include <algorithm>
#include <type_traits>
#include <exception>
#include <random>
#include <chrono>
#include <bit>

bool verbose = false;

static_assert(sizeof(uint64_t) == sizeof(unsigned long));
constexpr int bs = 64; // block size in bits

// Simple command line parser
// https://stackoverflow.com/questions/865668/parsing-command-line-arguments-in-c
class InputParser {
 public:
   InputParser (int argc, char *argv[]) {
     for (int i = 1; i < argc; ++i)
       this->tokens.push_back(std::string(argv[i]));
   }
   std::string get(const std::string &option) const {
     auto itr = std::find(this->tokens.begin(), this->tokens.end(), option);
     if (itr != this->tokens.end() && ++itr != this->tokens.end())
       return *itr;
     return "";
   }
   bool exists(const std::string &option) const {
     return std::find(this->tokens.begin(), this->tokens.end(), option) != this->tokens.end();
   }
 private:
   std::vector<std::string> tokens;
};

using vec64 = std::vector<uint64_t>;
using set64 = std::bitset<bs>;

// 0 -> 63, 1 -> 62, etc.
int reorder(const int k) {
  return (bs-1)-k;
}

bool parity(const uint64_t &v)
{
  return std::popcount(v) % 2; // C++20 feature
}

// Computes y = m*x. m is stored as a row-major matrix of 64 bit blocks.
void extract(vec64 &y, const vec64 &m, const vec64 &x)
{
  assert(m.size() == x.size() * y.size()*bs);
  for (unsigned i = 0; i < y.size(); i++) {
    set64 s;
    for (unsigned ib = 0; ib < bs; ib++) {
      bool par = false;
      for (unsigned j = 0; j < x.size(); j++) {
        const auto m1 = m[j+(i*bs+ib)*x.size()]; // row-major storage
        const auto x1 = x[j];
        const auto res = m1 & x1;
        const bool p = parity(res);
        par ^= p;
      }
      s.set(reorder(ib), par);
    }
    y[i] = s.to_ulong();
  }
}

template<typename T>
  void dump(const std::string label, const std::vector<T> &m, std::ostream &o = std::cout, const std::string br = "\n")
{
  o << label << "=";
  for (auto i = 0u; i < m.size(); i++)
    o << m[i] << br;
  o << std::endl;
}

void dumpbit(const std::string label, const vec64 &m, std::ostream &o = std::cout, const std::string br = "\n")
{
  o << label << "=";
  for (auto i = 0u; i < m.size(); i++)
    o << std::bitset<bs>(m[i]) << br;
  o << std::endl;
}

// Read values from a file to a vector. Number of entrie read is equal to the size of the vector.
void read(std::string fn, vec64 &m)
{
  std::ifstream f(fn);
  if (!f) throw std::runtime_error("Failed to open file " + fn);
  for (auto i = 0u; i < m.size(); i++) f >> m[i];
  if (!f) throw std::runtime_error("Failure reading from file " + fn);
}

// Construct a Toeplitz matrix with the first-row entries r and first-column entries c.
// m has dimensions l*n, containing blocks of 'bs' bits represented as integers.
void toeplitz(const vec64 &r, const vec64 &c, vec64 &m)
{
  const auto n = r.size();
  const auto l = c.size();
  assert(m.size() == n*l/bs);
  assert(n > 0);
  assert(l > 0);
  assert(r[0] == c[0]); // consistency check
  for (unsigned i = 0u; i < l; i++) { // first matrix index
    for (unsigned j = 0u; j < n/bs; j++) {
      set64 s;
      for (unsigned k = 0u; k < bs; k++) {
        const auto a = i;
        const auto b = k+j*bs; // second matrix index
        assert(a < c.size());
        assert(b < r.size());
        bool val = (a >= b ? c[a-b] : r[b-a]);
        s[reorder(k)] = val;
      }
      auto ndx = j+i*(n/bs);  // row-major storage
      assert(ndx < m.size());
      m[ndx] = s.to_ulong();
    }
  }
}

const unsigned seed = std::chrono::steady_clock::now().time_since_epoch().count();
std::default_random_engine dre(seed);

void randomize(vec64 &v)
{
  std::uniform_int_distribution<int> di(0,1);
  for (auto i = 0u; i < v.size(); i++)
    v[i] = di(dre);
}

int main(int argc, char *argv[])
{
  InputParser input(argc, argv);
  verbose = input.exists("-v");
  if (!input.exists("-n")) throw std::runtime_error("n must be defined");
  if (!input.exists("-l")) throw std::runtime_error("l must be defined");
  // Input block size in bits
  const unsigned n = stoi(input.get("-n"));
  if (n % bs != 0) throw std::invalid_argument("n must be a multiple of 64");
  // Output block size in bits
  const unsigned l = stoi(input.get("-l"));
  if (l % bs != 0) throw std::invalid_argument("l must be a multiple of 64");
  assert(l <= n);

  // y = m*x
  vec64 y(l/bs); // l columns
  vec64 m(l*n/bs); // l*n matrix
  vec64 x(n/bs); // n columns

  if (verbose) std::cerr << "y=" << y.size() << " m=" << m.size() << " x=" << x.size() << std::endl;

  if (input.exists("-m")) {
    const auto fn = input.get("-m");
    read(fn, m);
  }

  const bool rc_files = input.exists("-r") && input.exists("-c");
  const bool rc_random = input.exists("-R");
  const bool from_rc = rc_files || rc_random;

  vec64 r(n); // values of first row
  vec64 c(l); // values of first column
  if (rc_files) {
    const auto r_fn = input.get("-r");
    const auto c_fn = input.get("-c");
    read(r_fn, r);
    read(c_fn, c);
  }

  if (rc_random) {
    randomize(r);
    randomize(c);
    c[0] = r[0]; // must be the same!
  }

  if (from_rc) {
    if (verbose) dump("r", r, std::cerr);
    if (verbose) dump("c", c, std::cerr);
    toeplitz(r, c, m);
  }

  if (verbose) dump("m", m, std::cerr);
  if (verbose) dumpbit("m", m, std::cerr);

  const auto ifn = input.get("-i");
  const auto ofn = input.get("-o");
  std::ifstream isf;
  if (ifn != "") {
    isf.open(ifn, std::ios::binary);
    if (!isf) throw std::runtime_error("Failed to open " + ifn);
  }
  std::ofstream osf;
  if (ofn != "") {
    osf.open(ofn, std::ios::binary);
    if (!osf) throw std::runtime_error("Failed to open " + ofn);
  }

  std::istream & is = (input.exists("-i") ? isf : std::cin);
  std::ostream & os = (input.exists("-o") ? osf : std::cout);

  while (is) {
    is.read((char*)x.data(), x.size() * (bs/8)); // char has 8 bits
    if (is) {
      extract(y, m, x);
      os.write((char*)y.data(), y.size() * (bs/8));
    }
  }
}
