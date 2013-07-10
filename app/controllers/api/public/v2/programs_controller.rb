module Api::Public::V2
  class ProgramsController < BaseController

    before_filter :sanitize_slug, only: [:show]

    def index
      @programs = KpccProgram.all + ExternalProgram.all

      respond_with @programs
    end


    def show
      @program = KpccProgram.where(slug: @slug).first ||
        ExternalProgram.where(slug: @slug).first

      if !@program
        render_not_found and return false
      end

      respond_with @program
    end
  end
end
