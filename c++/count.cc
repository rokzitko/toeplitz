// Simple tool that generates counter output
// The counting interval and step are controlled by -b, -e and -s switches (begin, end, step)
// The output formatting is selected by -6 (binary in 64 chunks), -d (decimal) and -h (hexadecimal)
// Rok Zitko, March 2022

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <limits>

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

int main(int argc, char *argv[])
{
  InputParser input(argc, argv);

  const uint64_t begin = (input.exists("-b") ? std::stol(input.get("-b")) : 0);
  const uint64_t end = (input.exists("-e") ? std::stol(input.get("-e")) : std::numeric_limits<uint64_t>::max());
  const uint64_t step = (input.exists("-s") ? std::stol(input.get("-s")) : 1);
  const bool bin64 = input.exists("-6");
  const bool dec = input.exists("-d");
  const bool hex = input.exists("-h");

  for (uint64_t i = begin; i != end; i += step) {
    if (dec)
      std::cout << std::dec << i << std::endl;
    if (hex)
      std::cout << std::hex << i << std::endl;
    if (bin64)
      std::cout.write((char*)&i, sizeof(uint64_t));
  }
}
