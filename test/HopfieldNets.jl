fname = joinpath(dirname(pathof(HopfieldNets)), "..", "demo", "letters.jl")
include(fname)

patterns = hcat(X, O)

n = size(patterns, 1)

dnet = DiscreteHopfieldNet(n)
# The gain for the continuous network corresponds to an inverse temperature
# The smaller it is, the larger the thermal fluctuations, the more difficult
# is to distinguish minima.
cnet = ContinuousHopfieldNet(n, 10.0)

for (tset, net) in zip(["discrete", "continuous"], [dnet, cnet])
    @testset "$tset" begin
        train!(net, patterns)

        e0 = energy(net)
        settle!(net, 1_000, false)
        eFinal = energy(net)
        @assert e0 != eFinal

        for (letter, data) in zip(["X", "O"], [X, O])
            @testset "$letter" begin
                data_corrupt = copy(data)
                for i = 2:7
                    data_corrupt[i] *= -1
                end
                data_restored = associate!(net, data_corrupt)
                @test norm(data_corrupt - data_restored) > 1e-4
                @test norm(data - data_restored) < 1e-4
            end
        end
    end
end
