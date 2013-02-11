class Admin::ShowEpisodesController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = ShowEpisode

  define_list do
    column :headline
    column :show
    column :air_date
    column :status
    column :published_at
    
    filter :show_id, collection: -> { KpccProgram.all.map { |program| [program.to_title, program.id] } }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
