module Api::Public::V3
  class ProgramsController < BaseController

    before_filter :sanitize_slug, only: [:show]

    def index
      @programs = Program.all
      respond_with @programs
    end


    def show
      @program = Program.find_by_slug(@slug)

      if !@program
        render_not_found and return false
      end

      respond_with @program
    end
  end
end
