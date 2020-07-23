using Test
using HopfieldNets

import LinearAlgebra: norm

tests = ["HopfieldNets.jl", "storkey.jl"]

for path in tests
    @testset "testset: $path" begin
	    include(path)
    end
end
