function emulate(infile)
    X = 1
    output = Vector{Int64}()
    for cmd ∈ readlines(infile)
        if cmd == "noop"
            push!(output, X)
        else
            push!(output, X)
            push!(output, X)
            X = X + parse(Int64, cmd[6:end])
        end
    end
    output
end

function part1(infile)
    signal = emulate(infile)
    signal[20] * 20 + signal[60] * 60 + signal[100] * 100 + signal[140] * 140 + signal[180] * 180 + signal[220] * 220
end

function part2(infile)
    signal = emulate(infile)
    beam = Iterators.cycle(0:39)
    image = [abs(s - b) ≤ 1 for (s, b) ∈ Iterators.zip(signal, beam)]
    image = reshape(image, 40, :)'
    display(getindex.(".#", image .+ 1))
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
