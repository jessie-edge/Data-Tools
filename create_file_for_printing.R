library(tidycensus)
library(tigris)
library(sf)
library(dplyr)
library(ggplot2)
library(rayshader)
library(rayvertex)

options(tigris_use_cache = TRUE)

# Set your Census API key
census_api_key(key = "", install = TRUE, overwrite = TRUE)

# Example: Median household income in a county
income <- get_acs(
  geography = "tract",
  variables = "B19013_001",
  state = "CO",
  county = "Denver",
  geometry = TRUE,
  year = 2022) %>%
  filter(!is.na(estimate)) %>%
  st_transform(3857)

# Transform & Rasterize to projected CRS (meters)
income_sp <- as_Spatial(income)

r <- raster(income_sp)
res(r) <- 500  # adjust resolution (meters)

r_income <- rasterize(income_sp, r, field = "estimate")
r_income[is.na(r_income[])] <- 0

income_mat <- raster_to_matrix(r_income)

# 3D Shaping & Transformation 
# Scale for print: normalize to [0, 1] or mm range
scaled_mat <- income_mat / max(income_mat)

# Generate mesh
scene <- generate_ground_mesh(
  heightmap = scaled_mat,
  baseshape = "rectangle",
  material = material_list(diffuse = "#1f77b4")
)

# Optional: preview
rgl::clear3d()
rayvertex::rgl_render(scene)

# Export as STL
write_obj(scene, filename = "denver_income_model.obj")

# Convert to STL (rayvertex 1.1.1+ can write STL directly)
write_stl(scene, filename = "denver_income_model.stl")
