class FillInMissingAudiodir < ActiveRecord::Migration
  def up
    programs = {
      "marc-haefele"        => "haefele",
      "street-stories"      => "streetstories",
      "pacificdrift"        => "pacificdrift",
      "town-hall-journal"   => "townhalljournal",
      "titlewave"           => "titlewave",
      "ask-the-chief"       => "askthechief",
      "big-man-on-campus"   => "bmoc",
      "eatla"               => "eatla"
    }

    programs.each do |slug, dir|
      p = KpccProgram.find_by_slug!(slug)
      p.update_column(:audio_dir, dir)
    end
  end

  def down
  end
end
