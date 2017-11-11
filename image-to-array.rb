
require 'opencv'
include OpenCV

require 'color'

require 'pry'

RESOLUTION = [25,25] # desired output resolution: image will be split into this many blocks

image = CvMat.load(ARGV[0], CV_LOAD_IMAGE_COLOR)

out = image.clone

block_width = image.width / RESOLUTION[0]
block_height = image.height / RESOLUTION[1]

block_brightnesses = []
block_colors = []

RESOLUTION[0].times do |block_x|
    block_brightnesses[block_x] = []
    block_colors[block_x] = []

    RESOLUTION[1].times do |block_y|
        # get the corresponding block from the image
        block = image.subrect(block_width * block_x, block_height * block_y, block_width, block_height)
        # brightness of the block = avg(r,g,b) across all blocks, scaled to 100
        block_brightnesses[block_x][block_y] = (block.avg.to_a[0,3].sum / 3.0) * (100.0/256.0)
        # average color of the block
        block_colors[block_x][block_y] = block.avg

        # output for display: fill a block with the average color
        p1 = CvPoint.new(block_width * block_x, block_height * block_y)
        p2 = CvPoint.new(p1.x + block_width, p1.y + block_height)
        # thickness = -1 means fill the rectangle
        out.rectangle!(p1, p2, color: block_colors[block_x][block_y], thickness: -1)
    end
end

selected_colors = []

# pick good colors and reduce to a linear array with a single value from HSL spectrum
block_colors.each do |block_color_row|
    block_color_row.each do |block_color|
        r,g,b,_ = block_color.to_a
        c = Color::RGB.new(r,g,b).to_hsl
        # only pick colors with decent sat+lum
        selected_colors << (c.h * 100).round if (c.s > 0.2 && c.l < 0.9)
    end
end

p selected_colors

out.save_image("output.png")

