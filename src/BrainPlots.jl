module BrainPlots

using Pkg.Artifacts

function fsaverage_path(;hemi=:left)
	if hemi==:left
		return joinpath(artifact"fsaverage","fsaverage_pial_lh.stl")
	elseif hemi==:right
		return joinpath(artifact"fsaverage","fsaverage_pial_rh.stl")
	else
		error("Invalid arguments to `hemi`: only `:left` or `:right` allowed")
	end
end


end # module BrainPlots
