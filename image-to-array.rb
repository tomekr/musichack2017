
require 'opencv'
include OpenCV

require 'pry'

RESOLUTION = [5,5] # desired output resolution: image will be split into this many blocks

image = CvMat.load(ARGV[0], CV_LOAD_IMAGE_COLOR)

block_width = image.width / RESOLUTION[0]
block_height = image.height / RESOLUTION[1]

block_brightnesses = []

RESOLUTION[0].times do |block_x|
    block_brightnesses[block_x] = []

    RESOLUTION[1].times do |block_y|
        block = image.subrect(block_width * block_x, block_height * block_y, block_width, block_height)
        block_brightnesses[block_x][block_y] = (block.avg.to_a[0,3].sum / 3.0) * (100.0/256.0)
    end
end

binding.pry

