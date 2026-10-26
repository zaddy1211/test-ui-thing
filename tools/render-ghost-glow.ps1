# Render the SVG's white radial halo as a transparent PNG for Roblox custom assets.
Add-Type -AssemblyName System.Drawing
$haloPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../assets/kz-ghost-glow-v1.png'))
$halo = [System.Drawing.Bitmap]::new(256,320,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
try {
    for ($haloY = 0; $haloY -lt 320; $haloY++) {
        for ($haloX = 0; $haloX -lt 256; $haloX++) {
            $haloDx = ($haloX + .5 - 128) / 128
            $haloDy = ($haloY + .5 - 160) / 160
            $haloRadiusSquared = $haloDx * $haloDx + $haloDy * $haloDy
            $haloAlpha = if ($haloRadiusSquared -ge 1) { 0 } else {
                [int][Math]::Round(255 * .65 * ([Math]::Exp(-5 * $haloRadiusSquared) - [Math]::Exp(-5)) / (1 - [Math]::Exp(-5)))
            }
            $halo.SetPixel($haloX,$haloY,[System.Drawing.Color]::FromArgb($haloAlpha,255,255,255))
        }
    }
    $halo.Save($haloPath,[System.Drawing.Imaging.ImageFormat]::Png)
} finally { $halo.Dispose() }
Write-Output $haloPath
