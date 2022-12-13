function scan_sequence(infile, N)
    input = read(infile, String)
    z = zip(map(i -> Iterators.drop(input, i), 0:N-1)...)
    N-1 + findfirst(x -> length(unique(x)) == N, collect(z))
end

part1(infile) = scan_sequence(infile, 4)
part2(infile) = scan_sequence(infile, 14)

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
