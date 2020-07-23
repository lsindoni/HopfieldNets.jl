tests = ["HopfieldNets.jl", "storkey.jl"]

for path in tests
	include(path)
end
