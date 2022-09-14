require 'chunky_png'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])
    @barcode = barcode_output(@post)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @post.title.titleize.to_s,
               page_size: 'A4',
               template: 'posts/show',
               layout: 'pdf',
               formats: [:html],
               orientation: 'Landscape',
               lowquality: true,
               zoom: 1,
               dpi: 85
      end
    end
  end

  def barcode_output(post)
    barcode_string = post.barcode
    binding.pry
    barcode = Barby::Code128B.new(barcode_string)

    # PNG OUTPUT
    data = barcode.to_image(height: 15, margin: 5).to_data_url
  end

  private

  def scope
    ::Post.all.includes(:authors)
  end
end
