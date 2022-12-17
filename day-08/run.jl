read_grid(infile) = hcat(collect.(readlines(infile))...) .- '0'

do1_row(r) = accumulate(max, [-1; r])[1:end-1] .< r
do1_rrow(r) = reverse(do1_row(reverse(r)))
do1_half(g) = hcat([do1_row(g[i, :]) .| do1_rrow(g[i, :]) for i ∈ 1:size(g, 1)]...)
do1_grid(g) = do1_half(g) .| do1_half(g')'
part1(infile) = sum(do1_grid(read_grid(infile)))

do2_row(r) = [0; [1 + length(collect(Iterators.takewhile(x -> x < r[i], reverse(r[2:i-1])))) for i ∈ 2:length(r)]]
do2_rrow(r) = reverse(do2_row(reverse(r)))
do2_half(g) = hcat([do2_row(g[i, :]) .* do2_rrow(g[i, :]) for i ∈ 1:size(g, 1)]...)
do2_grid(g) = do2_half(g) .* do2_half(g')'
part2(infile) = maximum(do2_grid(read_grid(infile)))

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")

