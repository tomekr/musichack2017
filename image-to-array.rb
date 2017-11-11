
require 'opencv'
include OpenCV

require 'color'

require 'pry'

RESOLUTION = [25,25] # desired output resolution: image will be split into this many blocks

image = CvMat.load(ARGV[0], CV_LOAD_IMAGE_COLOR)

block_width = image.width / RESOLUTION[0]
block_height = image.height / RESOLUTION[1]

block_brightnesses = []
block_colors = []

RESOLUTION[0].times do |block_x|
    block_brightnesses[block_x] = []
    block_colors[block_x] = []

    RESOLUTION[1].times do |block_y|
        block = image.subrect(block_width * block_x, block_height * block_y, block_width, block_height)
        block_brightnesses[block_x][block_y] = (block.avg.to_a[0,3].sum / 3.0) * (100.0/256.0)
        block_colors[block_x][block_y] = block.avg
    end
end

selected_colors = []

block_colors.each do |block_color_row|
    block_color_row.each do |block_color|
        r,g,b,_ = block_color.to_a
        c = Color::RGB.new(r,g,b).to_hsl
        # only pick colors with decent sat+lum
        selected_colors << (c.h * 100).round if (c.s > 0.2 && c.l < 0.9)
    end
end

p selected_colors

