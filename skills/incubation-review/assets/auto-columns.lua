-- Remove explicit column widths from tables so typst can auto-size them
function Table(tbl)
  for i, colspec in ipairs(tbl.colspecs) do
    tbl.colspecs[i] = {colspec[1], nil}
  end
  return tbl
end
