#include <algorithm>
#include <cassert>
#include <fstream>
#include <vector>

struct Item {
    long value;
    long index;
};

static std::vector<Item> read_file(const char* const infile)
{
    std::vector<Item> result;
    std::ifstream instream(infile);
    long value, index = 0;
    while (instream >> value) {
        result.emplace_back(Item{value, index++});
    }
    return result;
}

static long get_value_at(const std::vector<Item>& l, long index)
{
    index %= l.size();
    return std::find_if(l.begin(), l.end(), [=](auto i) { return i.index == index; })->value;
}

static long get_index_of(const std::vector<Item>& l, long value)
{
    return std::find_if(l.begin(), l.end(), [=](auto i) { return i.value == value; })->index;
}

static void mix(std::vector<Item>& l)
{
    const long N = l.size() - 1;
    for (auto& item : l) {
        const long from = item.index;
        const long to = (N + ((item.index + item.value) % N)) % N;
        if (from == to) {
            continue;
        } else if (from < to) {
            for (auto& i : l) {
                if (i.index >= from && i.index <= to) {
                    i.index--;
                }
            }
        } else {
            for (auto& i : l) {
                if (i.index >= to && i.index <= from) {
                    i.index++;
                }
            }
        }
        item.index = to;
    }
}

static void print_result(std::vector<Item>& l)
{
    long zero_index = get_index_of(l, 0);
    printf("%li\n", get_value_at(l, zero_index + 1000) + get_value_at(l, zero_index + 2000) + get_value_at(l, zero_index + 3000));
}

static void part1(const char* const infile)
{
    std::vector<Item> l = read_file(infile);
    mix(l);
    print_result(l);
}

static void part2(const char* const infile)
{
    std::vector<Item> l = read_file(infile);
    for (auto& i : l) {
        i.value *= 811589153;
    }
    for (int i = 0; i < 10; i++) {
        mix(l);
    }
    print_result(l);
}

int main()
{
    printf("part 1 test: ");
    part1("testinput");
    printf("part 1 real: ");
    part1("input");

    printf("part 2 test: ");
    part2("testinput");
    printf("part 2 real: ");
    part2("input");
}
