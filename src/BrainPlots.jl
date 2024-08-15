module BrainPlots

using Pkg.Artifacts
using CairoMakie,FileIO,MeshIO

export fsaverage_path,fsaverage

"""
	fsaverage_path(;hemi={:left,:right})

Return a string of the STL artifact for the left or right FSAverage brain
"""
function fsaverage_path(;hemi=:left)
	if hemi==:left
		return joinpath(artifact"fsaverage","fsaverage_pial_lh.stl")
	elseif hemi==:right
		return joinpath(artifact"fsaverage","fsaverage_pial_rh.stl")
	else
		error("Invalid arguments to `hemi`: only `:left` or `:right` allowed")
	end
end

"""
	fsaverage(;hemi={:left,:right})

Returns the MeshIO object for the left or right FSAverage brain
"""
function fsaverage(;hemi=:left)
	return load(fsaverage_path(;hemi))
end


include("graphing.jl")

end # module BrainPlots
