# Get (formerly) Madeleine Brand program,
# and save its attributes (since they're mostly Brand/Martinez-related)
mb_program    = KpccProgram.find(21)
bm_attributes = mb_program.attributes

# Updated Madeleine Brand program to fix a few attributes
# The rest can be done manually via the CMS
mb_program.update_attributes!(slug: "madeleine-brand", title: "The Madeleine Brand Show")
mb_program.reload

# Create a new program for Brand/Martinez, and set its
# attributes to the saved attributes, and change the slug
bm_program = KpccProgram.create!(bm_attributes.merge!(slug: "brand-martinez"))

# Get Take Two
tt_program = KpccProgram.find(23)

# Set the end dates for madeleine brand and brand/martinez
# madeleine-brand = beginning of time      - 12am on Monday 8/20
# brand-martinez  = 12am on Monday 8/20    - 12am on Saturday, 9/22
# take-two        = 12am on Saturday, 9/22 - end of time
mb_end = Time.new(2012, 8, 20) # 12am on Monday, 8/20
bm_end = Time.new(2012, 9, 22) # 12am on Saturday, 9/22

# Setup conditions so we can use them on both episodes and segments
mb_conditions = ['published_at < ?', mb_end]        # Before mb_end
bm_conditions = { published_at: [mb_end..bm_end] }  # betewen mb_end and bm_end
tt_conditions = ['published_at > ?', bm_end]        # after bm_end

# Get all madeleine brand, brand/martinez, and cohen/martinez episodes/segments
# * Anything before Madeleine Brand ended goes to the Madeleine Brand Show
# * Anything between Madeleine Brand end and Brand/Martinez end goes to Brand/Martinez
# * Anything after Brand/Martinez ended goes to Take Two
mb_episodes = mb_program.episodes.where(*mb_conditions)
bm_episodes = mb_program.episodes.where(bm_conditions)
tt_episodes = mb_program.episodes.where(*tt_conditions)

mb_segments = mb_program.segments.where(*mb_conditions)
bm_segments = mb_program.segments.where(bm_conditions)
tt_segments = mb_program.segments.where(*tt_conditions)


# Now update the episodes and segments
# Madeleine Brand episodes/segments are already
# assigned properly, so we don't need to update them.
bm_episodes.update_all(show_id: bm_program.id)
tt_episodes.update_all(show_id: tt_program.id)

bm_segments.update_all(show_id: bm_program.id)
tt_segments.update_all(show_id: tt_program.id)

# Now just update the week of "Alex Cohen & A Martinez" episode titles to "Take Two"
tt_episodes.where("headline LIKE ?", "%Cohen%").each do |episode|
  episode.update_attribute(:headline, "Take Two for #{episode.air_date.strftime("%B %-d, %Y")}")
end

# Thats it
